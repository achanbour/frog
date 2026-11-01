# GEM-to-MLIR

1. Traverse the GEM expression and translate GEM types + operations into MLIR.
2. Generate an MLIR local kernel based on how `loopy` currently generates Impero code from GEM.

# Firedake's compilation pipeline

Firedrake relies on two main backend components:
1. TSFC
2. Loopy

## 1. TSFC: UFL -> GEM

`firedrake/tsfc/driver.py`: TSFC takes in UFL expressions (forms/integrals) and compiles them into assembly kernels.
- Input: UFL (pre-processed DAG)
- Output: GEM expressions

## 2. FIAT: GEM -> Impero
`fiat/gem/impero_utils.py`: `compile_gem` schedules GEM expressions into an Impero loop tree.
- Input: GEM
- Output: `ImperoC` object which is `Impero` tree + lists of temporaries and declarations, ready for C code generation.

## 3. Loopy: Impero -> loopy kernel
`firedrake/tsfc/loopy.py`: loopy walks the Impero tree, and each GEM expression (`Sum`, `Product`, `Indexed` etc.) is translated to a pymbolic expression.
- Input: Impero tree
- Output: Pymbolic expressions

> Pymbolic is the symbolic-expression library that loopy uses for defining the right-hand side of its instructions.

> The end result is a loopy kernel (`TranslationUnit` != source code) containing information such as loop domains, instructions and pymbolic expressions.

## 4. Loopy: loopy kernel -> C code
`pyop3/compile/loopy.py`: loopy generates code from the kernel object. `pyop3` takes the local loopy kernel, builds a global loop around it as a **second** loopy kernel. Finally, loopy generates C code out of the combined kernels. The C code then gets compiled and dynamically loaded during program execution.

# GEM to MLIR lowering

This is to be implemented at step 3 i.e., walk the Impero tree and emit MLIR operations where currently loopy emits loopy instructions and pymbolic expressions. Step 3 onward would be MLIR's job: `mlir-opt` passes + lowering into LLVM.

## TODO

Write a new generator that's meant to replace `generate_loopy` (in `tsfc/kernel_interface/firedrake_loopy.py`) i.e., instead of producing a loopy kernel out of the `ImperoC` object (produced by `compile_gem`), we need to generate an MLIR kernel. 

    The `ImperoC-to-MLIR` generator should take the same inputs as `generate_loopy` and its signature is therefore:

    ```
    generate_mlir(impero_c, args, scalar_type, kernel_name,...) -> MLIR module
    ```

At present, for a one-form such as `f*v*dx`, TSFC produces an `ImperoC` program (steps 1+2), and `tsfc/loopy.py:generate` turns it into a loopy kernel. Loopy turns that into C, which is compiled and run. The C code can be obtained by calling loopy's code generator which basically turns a loopy kernel (`TranslationUnit`) into source code (C):

```
import loopy as lp

print(lp.generate_code_v2(ast).device_code())
```

Inspect what the C code of a given loopy kernel looks like to figure out how a given Impero or GEM node should be lowered in MLIR

Compile/run the MLIR kernel and check numerical results agree.
  - Call the compiled loopy kernel directly or assemble through Firedrake
  - Lower MLIR with `mlir-opt` + run with `mlir-runner` OR compile to a shared library and call it from Python.

> Need to list every GEM + Impero node type and choose the MLIR dialect and op for each one

## My Notes

My understanding of what `loopy.py:generate` does:
1. Sets up the `LoopyContext`, mainly for book-keeping
2. Declares the temporaries
3. Creates instructions via the `statement` single-dispatch function, which returns for every Impero statement (`Evaluate`, `Return` etc.) a loopy instruction (statement).
   1. `expression` dispatches on the GEM node type and returns a pymbolic expression. 
4. Build loop domains (`create_domains`)
5. Assemble the kernel (`make_kernel`)

We can keep the same skeleton: **context** + **statement dispatcher** + **expression dispatcher**. The expression dispatcher will return an MLIR SSA value instead of a pymbolic. Instead of a tree, we emit ops on the go, in the right order inside the right loop.

Note that loopy has no loop instructions: loops are defined implicitly. On the other hand, we can express loops explicitly in MLIR (`scf.for` or `affine.for`)

   - Impero `For` becomes an MLIR `scf`/`affine` for loop.
   - Storage:
     - Temporaries become allocations `memref.alloca`?
     - Constants become global constants
     - Kernel arguments become function arguments
   - Memory access:
     - `Indexed` becomes a load `memref.load`
     - `Return` becomes a load + store?
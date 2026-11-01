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

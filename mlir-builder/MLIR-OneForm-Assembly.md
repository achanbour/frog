# One-form Assembly in PyOP3 with MLIR

Principally, one-form assembly works through

- GEM -> Impero pass
- Impero -> MLIR

## GEM -> Impero

GEM is generated in two places.

Global assembly is translated from PyOP3, in `pyop3/compile/gem.py::GemCompiler`.

Local assembly is in `tsfc/`.

Formerly, local assembly was passed to PyOP3 as a Loopy C function.
Now, local assembly is kept as GEM (see `firedrake/firedrake/tsfc_interface.py::as_pyop3_local_kernel`).

I would point you to `fiat/gem/{gem.py},{impero_utils.py}`, if you wanted to learn about GEM and Impero objects and design.
Impero is essentially scheduling + GEM. Hence, Impero is full of GEM nodes but placed around objects like `impero.For` and `impero.Accumulate`.

## Impero -> MLIR

The Impero code interacts with MLIR through the `GemExecutable` layer in `pyop3/compile/gem.py::GemExecutable`.

Impero is translated to MLIR in `pyop3/compile/mlir.py`. This translation is compiled and executed in `pyop3/cc.py`.

This is mildly complicated but the principal idea for Impero->MLIR is:

- Eager translation from Impero AST using a symbol table (active SSA values)
- Single-dispatch design pattern, where we walk through an Impero/GEM object by evaluating the children first. (DFS)
- We use a context manager for processing impero objects.
  - i.e: Enter a For object context, all child operations are, consequently, nested in an MLIR `scf.ForOp` (See `MLIRBuilder::process_for`)

The MLIR compiler passes are in `pyop3/cc.py` and differ between CPU and GPU paths. Some of this code is super ugly, Connor is taking it from my hands to refactor.

The generation of the Executable happens in `pyop3/insn/exec.py`.
If the executable finds a previously generated shared library (compiled MLIR), it will use this. Else, it will generate and compile MLIR.

At this stage, the runtime buffers (i.e. cell coefficients) are passed to the executable arguments. An example would be in `pyop3/insn/exec.py::CompiledCodeExecutor::__call__`.

Before passing arguments, buffers are distributed across MPI ranks - if running in parallel - through broadcast operations.

## MLIR -> CPU/GPU

Within the `MLIRBuilder`, the class property `_argument_devices` is populated and used to map if a buffer should be on CPU or GPU. Defaults to the current device context (see `pyop3/device.py::offloading`)

In `pyop3/cc.py`:

- We use the xDSL passpipeline for optimisations and targeting hardware.
- `mlir-translate` is used to translate MLIR dialect to LLVM.
- `clang` is used to compile the LLVM (llvm `.ll` to a shared object/library `.so`/`.a`/`.dylib` files)
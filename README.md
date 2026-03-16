# What is FRoG?

FRoG stands for Firedrake Routines on GPUs and comprises of experimental work on running Firedrake routines on AMD GPUs.

This work was initiated as part of the AMD Cross-community hackathon in Birmingham 11-13 March 2026.

## What was done
### The very first steps
We started with an MLIR script of a Firedrake-generated local kernel of a one-form assembly. In Firedrake, this operation is expressed as:

```
from firedrake import *

mesh = UnitSquareMesh(1, 1)
V = FunctionSpace(mesh, "CG", 2)

f = Function(V)
v = TestFunction(V)
assemble(f*v*dx)
```
The local kernel `mykernel.mlir` computes the integral expressed in this one-form over a single cell of the mesh.

After successfully executing `mykernel.mlir` on the CPU, we spent some time thinking on the how-s and why-s of executing finite element operator assembly on heterogenous hardware (CPU vs GPU). One thing we noted is that assembly on the GPU would make most sense if one is assembling operators in a [matrix free](https://www.firedrakeproject.org/matrix-free.html) way. For a problem requiring the matrix to be explicitly constructed and stored, assembling on the CPU and copying over to the GPU would only make sense if executing the solve operation (for which the GPU is most suited) once. However, this quickly becomes a major performance bottleneck particularly when used in a nonlinear solver or in a time-dependent scheme where the matrix needs to be re-assembled multiple times.
Crucially, when assembling operators in function spaces of degree>2, the matrix to be assembled is typically very large and so the performance is limited by the cost of reading the relevant matrix entries during the assembly operation. If assembly is matrix free then this cost is much less significant, and assembly is instead dominated by more FLOPS (which is really fast on a GPU).

### The crux of our work during the hackathon
With great pain, we managed to figure out the right compiler passes needed to execute a simplified vector addition kernel on AMD GPUs. These are:

for the first MLIR lowering phase:

```
mlir-opt vecadd_gpu_fixed.mlir \                                                                             --gpu-kernel-outlining \                                                                                                                              --convert-gpu-to-rocdl="chipset=gfx942" \
  --rocdl-attach-target="chip=gfx942" \
  --gpu-module-to-binary \
  --gpu-to-llvm \
  --convert-func-to-llvm \
  --convert-memref-to-llvm \
  --convert-arith-to-llvm \
  --reconcile-unrealized-casts \
  -o vecadd_gpu_ac_opt.mlir
```

for the MLIR compilation + execution:

```
mlir-runner vecadd_gpu_ac_opt.mlir \
  -e main \
  --entry-point-result=void \
  --shared-libs=/shared/apps/ubuntu/opt/rocm-7.2.0/llvm/lib/libmlir_runner_utils.so \
  --shared-libs=/shared/apps/ubuntu/opt/rocm-7.2.0/llvm/lib/libmlir_c_runner_utils.so \  
  --shared-libs=/shared/apps/ubuntu/opt/rocm-7.2.0/llvm/lib/libmlir_async_runtime.so \
  --shared-libs=$HOME/frog/libmlir_rocm_runtime.so \
  --shared-libs=/shared/apps/ubuntu/opt/rocm-7.2.0/llvm/lib/libclang-cpp.so \
  --shared-libs=/shared/apps/ubuntu/opt/rocm-7.2.0/llvm/lib/libLLVMOffload.so \
```
Figuring out the shared libraries required for successful compilation was difficult due to lack of documentation and workable examples. In particular, several required symbols in the lowered MLIR script produced by the first lowering phase couldn't be located by the MLIR compiler  as the required shared libraies were missing in the LLVM installation of ROCm on the cluster. These symbols are MLIR symbols representing wrappers around ROCm runtime wrappers. An example of this is https://github.com/llvm/llvm-project/blob/main/mlir/lib/ExecutionEngine/RocmRuntimeWrappers.cpp.

In order to verify that our kernel actually runs on the GPU and not the CPU, we pulled some profiling stats using AMD's native profiling tool [rocprofv3](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/how-to/using-rocprofv3.html)

```
rocprofv3 --hsa-trace --output-format csv -- <mlir-execution-command>
```

What we found particularly useful is to view these profiling results in [Perfetto](https://perfetto.dev). To do so, simply add the `--output-format pftrace` option when calling `rocprofv3`.

In addition to the above, we also started rewriting the local kernel computing the cell-local integral in a more GPU-compatible style. More on that to follow...


## What's left To-Do
- Complete rewriting our GPU kernel performing cell-local integration
    - Figure out how to best project the multi-dimensional tensor representing the integral quadrature sum onto GPU work groups (blocks + threads).
- Test the kernel with real input tensors:
    - Figure out how to extract the local kernel input tensors from Firedrake during the one form assembly
- Call the (compiled?) MLIR script from within Firedrake in `compile_global_kernel` function

## Resources & Useful Links
- Stephen Diehl's [blog](https://www.stephendiehl.com/posts/mlir_introduction/) on MLIR (needs updating though!)
- LLVM repo featuring [MLIR ROCm examples](https://github.com/llvm/llvm-project/tree/837b89fc0fc6d0ae7f68e835789ee62580314dcc/mlir/test/Integration/GPU/ROCM)

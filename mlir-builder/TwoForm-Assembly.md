# Barriers to using MLIRBuilder for two-forms

- At the moment we are processing `Dat`s not but not `Mat`s. The pyop3/GEM has not been processed for two-forms.

- There are assumptions in the `MLIRBuilder` that assume 1D indexing but that's not a general MLIR limitation.

- One forms lend themselves to better performance than two forms?

- The primary issue is that we use `PetscMatSetValues` and `PetscMatGetValues` - inline C commands  for setting/getting matrix values.
  - Inline C does not work for MLIR.
  - A possible solution is to move away from those.


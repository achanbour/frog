# GEM-to-MLIR

1. Traverse the GEM expression and translate GEM types + operations into MLIR.
2. Generate an MLIR local kernel based on how `loopy` currently generates Impero code from GEM.
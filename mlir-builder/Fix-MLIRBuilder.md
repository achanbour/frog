## Problem

gem.MathFunction does not widely support MathFunctions.
As can be seen in `pyop3/compile/mlir.py::process` (_process.register(gem.MathFunction)), only `abs` is supported.

The Loopy implementation is in `tsfc/loopy.py::_expression_mathfunction`, which can be used as a reference.

## MFE

A demo is given in `demo.py` for a `ln` function. 
This is only one example of a MathFunction, looking at more like `cos` and `sin` would be great. 

## Solution

Ideally, I don't want to introduce many more dialects beyond the existing `math` dialect used in this section.
However, I have not looked into how to support these math functions at all. 

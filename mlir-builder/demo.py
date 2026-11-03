from firedrake import *
import numpy as np

GEM = {
    "pyop3_compiler_parameters": {"backend": "gem"},
    "form_compiler_parameters": {"backend": "gem"},
}

mesh = UnitSquareMesh(3, 3)

def demo1():
    mesh = UnitSquareMesh(3, 3)
    V = FunctionSpace(mesh, "P", 2)

    x, y = SpatialCoordinate(mesh)
    v = TestFunction(V)

    gem_b = assemble(
        x*y*v*dx,
        **GEM,
    )

    # The P2 basis functions sum to 1, so the entries should sum to the integral of x*y
    # over the unit square - 1/4.
    total = gem_b.dat.data_ro.sum()
    print(f"sum of entries = {total!r}, expected 0.25")
    assert np.isclose(total, 0.25)

def demo2():
    # MathFunction: the natural logarithm of a function of the coordinates.
    V = FunctionSpace(mesh, "P", 2)

    x, y = SpatialCoordinate(mesh)
    v = TestFunction(V)

    gem_b = assemble(
        ln(1 + x*y)*v*dx,
        **GEM,
    )

    # Expected values are obtained from release-version of Firedrake
    # Can't run Loopy backend while Connor is updating GEM, so comparisons 
    # need to be against separate clone of Firedrake repo 
    total = gem_b.dat.data_ro.sum()
    norm = np.linalg.norm(gem_b.dat.data_ro)
    print(f"sum of entries = {total!r}, expected 0.20876139473537636")
    print(f"norm of entries = {norm!r}, expected 0.04709011908005676")
    assert np.isclose(total, 0.20876139473537636)
    assert np.isclose(norm, 0.04709011908005676)

# demo1() # This should work and pass
demo2() # MFE

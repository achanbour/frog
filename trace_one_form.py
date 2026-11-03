from firedrake import *

GEM = {
    "pyop3_compiler_parameters": {"backend": "gem"},
    "form_compiler_parameters": {"backend": "gem"},
}

mesh = UnitSquareMesh(1, 1)
V = FunctionSpace(mesh, "CG", 1)
f = Function(V)
v = TestFunction(V)
form = f * v * dx
assemble(form, **GEM)
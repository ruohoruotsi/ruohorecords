from coldtype import *

@animation((250, 250), bg=0, timeline=24)
def flyinga(f):
    return PS([
        (P().rect(f.a.r)
            .f(hsl(f.e("qeio", 0)))),
        (StSt("A", Font.MutatorSans(),
            50, wght=0.2)
            .align(f.a.r)
            .scale(f.e("eei", 0, rng=(1, 51)))
            .rotate(f.e("qeio", 0, rng=(0, 360)))
            .f(1))])
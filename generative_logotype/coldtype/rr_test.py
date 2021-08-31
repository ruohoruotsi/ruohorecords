from coldtype import *

@renderable()
def test(r):
    return DATPen().oval(r.inset(110)).f(hsl(0.1))
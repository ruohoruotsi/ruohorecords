from coldtype import *


# pass a rect to an oval, with frame? taking a color tuple
# what is a DATPen
@renderable()
def test(r):
    return DATPen().oval(r).f((0.1,0.2,0.6))
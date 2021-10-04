from coldtype import *


# pass a rect to an oval, with frame? taking a color tuple
# what is a DATPen?
# @renderable()
# def test(r):
#     return DATPen().oval(r).f((0.1,0.2,0.6))

# What is P()? f.a.r = frame.animation.rect, black, inset 300pixels
# with sinusoidal easing in/out
@animation(timeline=10) # duration of 10 frames
def easing_example(f):
    square = P(f.a.r.inset(300)).f(0)
    return square.rotate(f.e("seio", 1, rng=(-3, 2)))
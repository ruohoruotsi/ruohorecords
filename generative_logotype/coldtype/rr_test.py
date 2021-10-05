from coldtype import *


# Pass an 300px inset rect containing an oval, with frame? taking a 
# color tuple. What is a DATPen? <-- fontTools RecordingPen, a vector 
# representation in Coldtype
#######################################################################
# @renderable()
# def test(r:Rect):
#     # return DATPen().oval(r.inset(300)).f((0.3, 0.2, 0.6))
#     return DATPen().rect(r.inset(300)).f(hsl(random()))


#######################################################################
# Multiple Renderables
# Built in fonts are ColdtypeObviously, RecursiveMono, MutatorSans
@renderable((1440, 1080))
def sample_text(r):
    return PS([
        P().oval(r.inset(20)).f(hsl(random())),
        (StSt("RUOHO",
        Font.))
        ])


#######################################################################
# What is P()? f.a.r = frame.animation.rect, black, inset 300pixels
# with sinusoidal easing in/out
# @animation(timeline=10) # duration of 10 frames
# def easing_example(f):
#     square = P(f.a.r.inset(300)).f(0)
#     return square.rotate(f.e("seio", 1, rng=(-3, 2)))
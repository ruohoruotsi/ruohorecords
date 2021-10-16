from coldtype import *

# Basics

# Pass an 300px inset rect containing an oval, with frame? taking a 
# color tuple. What is a DATPen? <-- fontTools RecordingPen, a vector 
# representation in Coldtype. DATPen vs P()??
#######################################################################
# @renderable((600, 600))
# def test(r:Rect):
#     #return DATPen().oval(r.inset(300)).f((0.3, 0.2, 0.6))
#     # return DATPen().rect(r.inset(300)).f(hsl(random()))
#     return P().rect(r.inset(50)).f(hsl(0.9))


# What is P()? P() == "pen, DATPen"
# f.a.r = frame.animation.rect, black, inset 300pixels
# with sinusoidal easing in/out
#######################################################################
# @animation(timeline=10) # duration of 10 frames
# def easing_example(f):
#     square = P(f.a.r.inset(300)).f(0)
#     return square.rotate(f.e("seio", 1, rng=(-3, 2)))


# Multiple Renderables
# Built in fonts are ColdtypeObviously, RecursiveMono, MutatorSans
#######################################################################
# @renderable((800, 600))
# def sample_text(r):
#     return PS([                                 # list for renderables
#         P().oval(r.inset(20)).f(hsl(random())), # renderable #1

#         (StSt("DOPO POTLY",                   # renderable #2
#         Font.ColdtypeObviously(), 200,
#         wdth=0, tu=100, rotate=15)
#         .align(r)
#         .f(1))])


# 
coldtype_obv = Font.ColdtypeObviously()
@renderable((800,800))
def basic(r):
    # return (StSt("POTLY", coldtype_obv, 150).align(r))
    pens = (StSt("POTLY", coldtype_obv, 150,
        wdth=0.5, rotate=10, tu=160)
        .align(r)
        .f(hsl(0.8, s=0.75)))

    print(pens.tree())
    pens[0].rotate(180)
    pens[-1].rotate(180)
    pens[3].rotate(180)
    return pens
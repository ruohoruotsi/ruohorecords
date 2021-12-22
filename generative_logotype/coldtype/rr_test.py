from coldtype import *
from coldtype.text.reader import offset
coldtype_obv = Font.ColdtypeObviously()

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


# Less Basic Text
#######################################################################
# @renderable((800,800))
# def basic(r):
#     # return (StSt("POTLY", coldtype_obv, 150).align(r))  # lessbasic
#     pens = (StSt("POTLY", coldtype_obv, 150,              # print_tree
#         wdth=0.5, rotate=10, tu=160)
#         .align(r)
#         # .f(hsl(0.8, s=0.75)))                           # no gradient
#         .f(Gradient.Vertical(r, hsl(0.5, s=0.8), hsl(0.8, s=0.75))))

#     print(pens.tree())
#     pens[0].rotate(180)
#     pens[-1].rotate(180)
#     pens[3].rotate(180)
#     return pens

# Drop Shadows
#######################################################################
# @renderable((1000, 200))
# def simpledrop(r):
#     pens = (StSt("LYPT CO", coldtype_obv, 150,
#         wdth=0.5, rotate=11, tu=250)
#         .align(r)
#         .f(1))
#     return DATPens([ 
#         pens.copy().translate(10, -10).f(0) # shadow
#         ,pens.s(hsl(0.9)).sw(3)             # top version of text
#     ])

# @renderable((1000, 200))
# def ro(r):
#     return (StSt("LPTT COOO", coldtype_obv, 150,
#         width=0.5, rotate=10, tu=100, ro=1)
#         .align(r)
#         .f(1)
#         .pen()
#         .layer(
#             lambda p: p.castshadow(-45, 50).f(0),
#             lambda p: p.s(hsl(0.9)).sw(3))
#         .align(r, th=1, tv=1))

# @renderable((1000, 200))
# def stroke_shadow(r):
#     return (StSt("LYYYT CO", coldtype_obv, 160,
#     width=1, rotate=10, tu=100, ro=1)
#     .align(r)
#     .f(1)
#     .layer(
#         lambda ps: ps.pmap(lambda p: p
#         .outline(10)
#         .removeOverlap()
#         .castshadow(-24, 50)
#         .f(None)
#         .s(hsl(0.6, s=1, l=0.4))
#         .sw(4)),
#         lambda ps: ps.s(hsl(0.9)).sw(4))
#     .align(r, th=1, tv=1)
#     )

# cleanup a little spec in the above drop shadow rendering
# it may depend on the (canvas/char) dimensions chosen too, je pense 
# @renderable((1000, 200))
# def stroke_shadow_cleanup(r):
#     def shadow_and_cleanup(p):
#         return (p
#             .outline(10)
#             .reverse()
#             .removeOverlap()
#             .castshadow(-5, 220)
#             # .filter_contours( lambda j, c:
#             #     c.bounds().w > 50)
#             .f(None)
#             .s(hsl(0.6, s=1, l=0.4))
#             .sw(4))

#     return (StSt("C", coldtype_obv, 200,
#         wdth=0.5, rotate=10, tu=100, ro=1)
#         .align(r)
#         .f(1)
#         .layer(
#             lambda ps: ps.pmap(shadow_and_cleanup),
#             lambda ps: ps.s(hsl(0.9)).sw(4))
#         .align(r, th=1, tv=1)
#         )

# Multi-line, just add a \n
#######################################################################
# @renderable((1000, 550))
# def multiline(r):
#     return (StSt("COLDTYPE\nTYPECOLD", coldtype_obv, 300,
#         wdth=1, fit=500)
#         .align(r)
#         .f(0))

# Text on a path
# @renderable((1000, 1000))
# def on_a_path(r):
#     circle = P().oval(r.inset(250)).reverse()
#     return (StSt("COLDTYPE", coldtype_obv, 200, width=1)
#         .distribute_on_path(circle, offset=275)
#         .f(0)
#     )

#######################################################################
#######################################################################
# Finally RR font experiments. Labyrinth FTW!
rr_ttf = Font("rr_fonts/lavirint/lavirint.ttf")
# 1) Vertical Gradient looks nice
# 2) small colorized drop shadow
# 3) horizontal gradient?
# 
#######################################################################
#######################################################################
# IOHAVOC TODO, make this renderable match the size of the Bandcamp header
@renderable((1000, 250))
# def ruoho_records_basic(r):
#     return (StSt("RUOHO RECORDS", rr_ttf, 80, width=1.0, r=1)
#         # .f(hsl(random()))
#         .f(Gradient.H(r,
#             hsl(0.05, s=0.75),
#             hsl(0.8, s=0.75)))
#         .understroke(s=0, sw=3)  # OMG what is this??
#         .align(r)
#         )


# try stroke shadow - MEH
# def stroke_shadow(r):
#     return (StSt("RUOHO RECORDS", rr_ttf, 80, 
#         wdth=1, rotate=0, tu=10, ro=1)
#         .align(r)
#         .f(1)
#         .layer(
#             lambda ps: ps.pmap(lambda p: p
#                 .outline(10)
#                 .removeOverlap()
#                 .castshadow(-15, 20)
#                 .f(None)
#                 .s(hsl(0.6, s=1, l=0.4))
#                 .sw(4)),
#             lambda ps: ps.s(hsl(0.9)).sw(4))
#         .align(r, th=1, tv=1))

# Vertical gradient is nice thoguh
# def ruoho_records_vertical(r):
#     return (StSt("RUOHO RECORDS", rr_ttf, 80, 
#         width=1.0, rotate=0, tu=40)
#         .f(Gradient.Vertical(r,
#             hsl(0.01, s=0.8),
#             hsl(0.2, s=0.75))
#             )
#         # .understroke(s=0, sw=1)
#         .align(r)
#     )

# Drop shadow
# def simpledrop(r):
#     return (StSt("RUOHO RECORDS", rr_ttf, 80,
#         wdth=1.0, rotate=0, tu=40, ro=1)
#         .align(r)
#         .f(Gradient.H(r, hsl(0.74, s=0.15, l=0.25), 
#                           hsl(0.1, s=0.75, l=0.35)))
#         .pen()
#         .layer(
#             lambda p: p.castshadow(-45, 20)
#                 .f(Gradient.H(r, hsl(0.03, s=0.15, l=0.05), 
#                                  hsl(0.09, s=0.25, l=0.15))),
#             lambda p: p.s(hsl(0.2)).sw(1))
#         .align(r, th=1, tv=1))

# Straight classic black
# def ruoho_records_classic_black(r):
#     return (StSt("RUOHO RECORDS", rr_ttf, 80, 
#         width=1.0, rotate=0, tu=40)
#         .f(0)
#         # .f(Gradient.H(r, hsl(0.05, s=0.75), hsl(0.8, s=0.75)))
#         # .f(Gradient.Vertical(r, hsl(0.5, s=0.8), hsl(0.8, s=0.75)))
#         .understroke(s=0, sw=1)  # OMG what is this??
#         .align(r)
#         )

# Horizontal gradient
# def ruoho_records_horizontal_gradient(r):
#     return (StSt("RUOHO RECORDS", rr_ttf, 80, 
#         width=1.0, rotate=0, tu=40)
#         .f(Gradient.H(r, hsl(0.03, s=0.15, l=0.25), 
#                          hsl(0.09, s=0.75, l=0.35)))
#         .understroke(s=0, sw=1)
#         .align(r)
#         )

def ruoho_records_classic_black_understroke(r):
    return (StSt("RUOHO RECORDS", rr_ttf, 100, 
        width=1.0, rotate=0, tu=-220)
        .f(0)
        .reverse_pens() # overlaps pens L->R
        # .f(Gradient.H(r, hsl(0.05, s=0.75), hsl(0.8, s=0.75)))
        .f(Gradient.Vertical(r, hsl(0.01, l=0), 
                                hsl(0.09, l=0.5)))
        .understroke(s=1, sw=10)
        .align(r)
        )
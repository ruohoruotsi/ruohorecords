from coldtype import *
from coldtype.fx.skia import phototype

rr_ttf = Font("rr_fonts/lavirint/lavirint.ttf")

#----------------------------------------------------------------------
@animation((1080, 180), timeline=60, render_bg=1)
def rr_colour_pulse_2secs(f):
    return P(
            [
                (P(f.a.r)
                    .f(hsl(f.e("eeio", 1, rng=(0.1, 0.2)), 0.8, 0.6))
                    ),
                (StSt("RUOHO RECORDS", rr_ttf,
                    font_size=f.e("eeio", 1, rng=(85, 92)),
                    #wdth=f.e("eeio", 1, rng=[0, 90]),
                    #wght=f.e("seio", 1, rng=[0, 18]), # Lavrint doesn't have variable weight
                    leading=5)
                    .f(0)
                    .understroke(s=0, sw=1)  # OMG what is this??
                    .align(f.a.r)
                )
            ]
        )
# # Shift space to render
# release = vari.export("h264")

#----------------------------------------------------------------------
# Note, if you don't return a color canvas, then the type will be 
# rendered on transparent background
# @animation((1000, 250), timeline=60, bg=hsl(0.42, 0.37, 0.16))
# def gw2(f):
#     def styler(g):
#         fa = f.adj(-g.i*3)
#         return [
#             Style(rr_ttf, 80),
#             dict(font_size=f.e("seio", 1, rng=(40, 70)))
#         ]
#     return (Glyphwise("RUOHO RECORDS", styler)
#         .align(f.a.r, ty=0)
#         .f(1))
# Shift space to render
# release = gw2.export("h264")

#----------------------------------------------------------------------
# @animation((975, 180),
#     bg=hsl(0.45, 0.65, 1.0),
#     timeline=Timeline(30, 18))
# def bandcamp_header_banner(f):
#     return (StSt("RUOHO RECORDS", rr_ttf,
#         ro=1,
#         font_size=95,
#         rotate=f.e("ceio", 1, rng=(-10, 0)),
#         tu=f.e("eeio", 1, rng=(100, -100)))
#         .align(f.a.r)
#         .reversePens() # overlaps pens L->R
#         .f(1)
#         .understroke(sw=10)
#         .ch(phototype(f.a.r, blur=2, 
#                             cut=110, 
#                             cutw=30, 
#                             fill=hsl(h=0.5, s=0.5, l=0.0))))

#----------------------------------------------------------------------
# Gently rocking "R"
# @animation((500, 500),
#     bg=hsl(0.45, 0.65, 1.0),
#     timeline=Timeline(30, 18))
# def bandcamp_logo(f):
#     return (StSt("R", rr_ttf,
#         ro=1,
#         font_size=300,
#         rotate=f.e("ceio", 1, rng=(-10, 0)),
#         tu=f.e("eeio", 1, rng=(100, -100)))
#         .align(f.a.r)
#         .reversePens() # overlaps pens L->R
#         .f(1)
#         .understroke(s=200, sw=6)
#         .ch(phototype(f.a.r, blur=2, 
#                             cut=50, 
#                             cutw=30, 
#                             fill=hsl(h=0.5, s=0.5, l=0.0))))

#----------------------------------------------------------------------
# @animation((2048, 1152),
#     bg=hsl(0.45, 0.65, 1.0),
#     timeline=Timeline(30, 18))
# def youtube_header_banner(f):
#     return (StSt("RUOHO RECORDS", rr_ttf,
#         ro=1,
#         font_size=116,
#         rotate=f.e("ceio", 1, rng=(-10, 0)),
#         tu=f.e("eeio", 1, rng=(100, -100)))
#         .align(f.a.r)
#         .reversePens() # overlaps pens L->R
#         .f(1)
#         .understroke(sw=10)
#         .ch(phototype(f.a.r, blur=2, 
#                             cut=110, 
#                             cutw=30, 
#                             fill=hsl(h=0.5, s=0.5, l=0.0))))
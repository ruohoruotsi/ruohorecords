from coldtype import *
from coldtype.text.reader import offset
from coldtype.fx.skia import phototype

rr_ttf = Font("rr_fonts/lavirint/lavirint.ttf")

@animation((500, 500),
    timeline=Timeline(30, 18))
def understroke(f):
    return (StSt("R", rr_ttf,
        ro=1,
        font_size=300,
        rotate=f.e("ceio", 1, rng=(-10, 0)),
        tu=f.e("eeio", 1, rng=(100, -100)))
        .align(f.a.r)
        .reverse_pens() # overlaps pens L->R
        .f(1)
        .understroke(sw=10)
        .ch(phototype(f.a.r, blur=6, 
                            cut=110, 
                            cutw=10, 
                            fill=hsl(h=0.5, s=0.5, l=0.0)
                            )))
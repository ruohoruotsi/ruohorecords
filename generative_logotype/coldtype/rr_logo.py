from coldtype import *
from coldtype.fx.skia import phototype

rr_fonts_path = "/Users/iroro/github/ruohorecords/generative_logotype/coldtype/rr_fonts/"
rr_ttf = Font.Cacheable(rr_fonts_path + "lavirint/lavirint.ttf")

# Gently rocking logo style "R" on a transparent background
@animation((500, 500), timeline=Timeline(30, 18))
def understroke(f):
    return (StSt("R", rr_ttf,
        ro=1,
        font_size=300,
        rotate=f.e("ceio", 1, rng=(-10, 0)),
        tu=f.e("eeio", 1, rng=(100, -100)))
        .align(f.a.r)
        .reversePens() # overlaps pens L->R
        .f(1)
        .understroke(sw=10)
        .ch(phototype(f.a.r, blur=6, 
                            cut=110, 
                            cutw=10, 
                            fill=hsl(h=0.5, s=0.5, l=0.0)
                            )))
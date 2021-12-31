from coldtype import *
from coldtype.fx.skia import phototype

rr_ttf = Font("rr_fonts/lavirint/lavirint.ttf")

@animation((1920, 1080), timeline=960, storyboard=[120], render_bg=1)
def vari(f):

    return PS([
            # (P(f.a.r)
            #     .f(hsl(f.e("eeio", 1, rng=(0.1, 0.2)), 0.8, 0.6))),

    (StSt("RUOHO RECORDS", rr_ttf,
        ro=1,
        font_size=f.e("seio", 1, rng=(1, 2920)),
        tu=f.e("eeio", 1, rng=(100, -100)))
        .align(f.a.r)
        .reverse_pens() # overlaps pens L->R
        .f(1)
        .understroke(sw=10)
        .ch(phototype(f.a.r, blur=2, 
                            cut=100, 
                            cutw=30, 
                            fill=hsl(h=0.5, s=0.5, l=0.0))))


    ])
from coldtype import *
from coldtype.fx.skia import phototype

rr_fonts_path = "/Users/iroro/github/ruohorecords/generative_logotype/coldtype/rr_fonts/"
rr_ttf = Font.Cacheable(rr_fonts_path + "lavirint/lavirint.ttf")

@animation((1920, 1080), timeline=960, render_bg=1)
def rr_splash(f):

    return P([
            #splash of colour
            (P(f.a.r)
                .f(hsl(f.e("eeio", 1, rng=(0.1, 0.2)), 0.8, 0.6))),

            StSt("RUOHO RECORDS", rr_ttf,
                ro=1,
                font_size=f.e("seio", 1, rng=(1, 2920)),
                tu=f.e("seio", 1, rng=(100, -100)))
            .align(f.a.r)
            .reversePens() # overlaps pens L->R
            .f(1)
            .understroke(sw=40 )
            .ch(phototype(f.a.r, 
                        blur=2, 
                        cut=110, 
                        cutw=90, 
                        fill=hsl(h=0.5, s=0.5, l=0.0)
                        )
                )
    ])
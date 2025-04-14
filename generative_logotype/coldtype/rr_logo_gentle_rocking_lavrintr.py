from coldtype import *
from coldtype.fx.skia import phototype

rr_fonts_path = "/Users/iroro/github/ruohorecords/generative_logotype/coldtype/rr_fonts/"
rr_ttf = Font.Cacheable(rr_fonts_path + "lavirint/lavirint.ttf")

# Gently rocking logo style "R"
@animation((500, 500), bg=hsl(0.45, 0.65, 1.0), timeline=Timeline(30, 18))
def gently_rocking_single_lavrint_r(f):
    return (StSt("R", rr_ttf,
        ro=1,
        font_size=300,
        rotate=f.e("ceio", 1, rng=(-10, 0)),
        tu=f.e("eeio", 1, rng=(100, -100)))
        .align(f.a.r)
        .reversePens() # overlaps pens L->R
        .f(1)
        .understroke(s=200, sw=6)
        .ch(phototype(f.a.r, blur=2, 
                            cut=50, 
                            cutw=30, 
                            fill=hsl(h=0.5, s=0.5, l=0.0))))

# Shift space to render
# release = rr_anim_gently_rocking_single_lavrint_r.export("h264")
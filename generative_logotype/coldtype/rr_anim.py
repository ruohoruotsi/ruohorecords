from coldtype import *

rr_ttf = Font("rr_fonts/lavirint/lavirint.ttf")

@animation((1080, 540), timeline=60, storyboard=[30], render_bg=1)
def vari(f):
    return (StSt("RUOHO RECORDS", rr_ttf,
        font_size=f.e("seio", 1, rng=(20, 80)),
        # wdth=f.e("eeio", 1, rng=[0, 10]),
        # wght=f.e("seio", 1, rng=[0,18]),
        leading=5)
        .f(0)
        .understroke(s=0, sw=1)  # OMG what is this??
        .align(f.a.r))

# Shift space to render
release = vari.export("h264")
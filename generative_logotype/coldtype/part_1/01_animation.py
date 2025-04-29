from coldtype import *

@animation((1080, 540), timeline=60, render_bg=1)
def vari(f):
    return (StSt("Ruoho\nRecords".upper(), Font.MutatorSans(),
        font_size=f.e("eeio", 1, rng=(110, 70)),
        wdth=f.e("eeio", 1, rng=[0, 10]),
        wght=f.e("seio", 1, rng=[0,18]),
        tu=-30,
        leading=20)
        .align(f.a.r)
        .f(0)
        )

# Shift space to render
release = vari.export("h264")
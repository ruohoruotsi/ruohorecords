from coldtype import *
from coldtype.fx.skia import phototype

rr_fonts_path = "/Users/iroro/github/ruohorecords/generative_logotype/coldtype/rr_fonts/"
rr_ttf = Font.Cacheable(rr_fonts_path + "lavirint/lavirint.ttf")
#rr_ttf = Font.Cacheable(rr_fonts_path + "bomb_factory/bombfact.ttf")
#rr_ttf = Font.Cacheable(rr_fonts_path + "masked/masked.ttf")
#rr_ttf = Font.Cacheable(rr_fonts_path + "unicode-0024.regular.ttf")
#rr_ttf = Font.Cacheable(rr_fonts_path + "Square One.ttf")

rr_string = "RUOHO RECORDS"

# bandcamp header dims: (975, 180), font_size=90
# youtube header dims: (2048, 1152), font_size=116

@animation((1080, 180), timeline=60, render_bg=1)
def rr_anim(f):

    return rr_colour_pulse_2secs(f)
#    return glyphwise_per_char_styler(f)
#    return bandcamp_header_banner(f)

def rr_colour_pulse_2secs(f):
    return P([
                P(f.a.r)
                .f(hsl(f.e("eeio", 1, rng=(0.1, 0.2)), 0.8, 0.6))
                ,
                (StSt(rr_string, rr_ttf,
                    font_size=f.e("eeio", 1, rng=(80, 90)),
                    # wdth=f.e("eeio", 1, rng=[0, 90]),
                    # wght=f.e("seio", 1, rng=[0, 18]), # Lavrint doesn't have variable weight
                    leading=5)
                .f(0)
                .understroke(s=0, sw=1)  # OMG this is the magic
                .align(f.a.r)
                )
                ,
                P(f.a.r).inset(5, 5).outline(5).f(0) # border
            ])


# Note, if you don't return a color canvas, then the type will be 
# rendered on transparent background
def glyphwise_per_char_styler(f):
    def styler(g):
        fa = f.adj(-g.i*3)
        return [
                Style(font=rr_ttf, font_size=80)
                ,
                dict(
                    font_size=f.e("seio", 1, rng=(80, 90)),
                    rotate=f.e("seio", 1, rng=(0, -15)),
                    wght=fa.e("seio", 1)
                    )
                ]
    
    return P([
                P(f.a.r)
                .f(hsl(f.e("eeio", 1, rng=(0.1, 0.2)), 0.8, 0.6))
            ,
                Glyphwise(rr_string, styler)
                    .align(f.a.r, ty=30)
                    .f(0)
            ,
                P(f.a.r).inset(5, 5).outline(5).f(0) # border
            ])


def bandcamp_header_banner(f):
    return P([
                P(f.a.r)
                .f(1)
            ,
                StSt(rr_string, rr_ttf
                    ,ro=1
                    ,font_size=90
                    ,rotate=f.e("ceio", 1, rng=(-10, 0))
                    ,tu=f.e("eeio", 1, rng=(100, -100))
                )
            .align(f.a.r)
            .reversePens() # overlaps pens L->R
            .f(1)
            .understroke(sw=10)  # this makes 
            .ch(phototype(f.a.r, # this makes the nice round edges
                        blur=2, 
                        cut=110, 
                        cutw=30, 
                        fill=hsl(h=0.5, s=0.5, l=0.0)
                        )
                )
            ,
                P(f.a.r).inset(5, 5).outline(5).f(0) # border
            ])

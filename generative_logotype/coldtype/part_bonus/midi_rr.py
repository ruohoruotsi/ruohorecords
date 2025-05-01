from coldtype import *
from coldtype.fx.skia import phototype
from coldtype.fx.motion import filmjitter

rr_ttf = Font.ColdtypeObviously()

midi = MidiTimeline(
    ººsiblingºº("../media/drums.mid")
    , duration=120
    , bpm=120
    , fps=30)

@animation(timeline=midi, bg=0, render_bg=1)
def anim(f):
    drums = f.t
    def de(n, pre=3, post=20, rng=(0, 1)):
        retval = drums.ki(n).adsr([pre, post], ["seio", "seio"], r=rng)
        print("n {}, drums.ki {}".format(n, retval))
        return retval

    # this array's values map each individual letter, so g.i is a single Glyph
    # each letter can then be orchestrated via a MIDI timeline (.mid)
    grvts = [
        de(36, 5, 20), # C
        de(37, 3, 20), # O
        de(38, 3, 30), # L
        de(42, 3, 30), # D
        de(50, 3, 50), # T
        de(43, 3, 30), # Y
        de(45, 3, 30), # P
        de(47, 3, 30), # E
    ]

    return (Glyphwise("COLD\nTYPE", 
                    lambda g: [
                            Style(rr_ttf, 210, wdth=1, wght=1, ro=1),
                            dict(
                                tu=1-grvts[g.i],
                                wdth=grvts[g.i],
                                wght=1-grvts[g.i]
                                )
                            ]
                    )
        .track(30, v=1)
        .xalign(f.a.r, th=0)
        .align(f.a.r, th=0)
        .translate(0, 25)
        .fssw(-1, 1, 7)
        .skew(de(47, 8, 10)) # iohavoc
        .layer(
            lambda p: p
                .ch(filmjitter(f.e("l"), 10, speed=(5, 10), scale=(1, 2)))
                .ch(phototype(f.a.r, blur=20, cut=90, cutw=90, fill=hsl(0.9, 1, 0.75))),
            lambda p: p
                .ch(filmjitter(f.e("l"), 5, speed=(5, 10), scale=(1, 2)))
                .ch(phototype(f.a.r, blur=3, cut=90, cutw=20, fill=hsl(0.3, 1, 0.75)))
                #.blendmode(BlendMode.Cycle(67))
        )
    )

release = anim.export("h264",
    loops=8,
    audio="media/drums_and_keys.wav",
    audio_loops=4,
    vf="eq=brightness=0.0:saturation=1.5")
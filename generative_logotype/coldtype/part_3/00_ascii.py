from coldtype import *
from coldtype.timing.nle.ascii import AsciiTimeline

at = AsciiTimeline(2, 24, """
                                <
    [R              ]
        [U          ]
            [O      ]
                [H      ]    
                        [W        ]
""")

@animation((1080, 540), timeline=at, bg=hsl(0.65))
def ascii(f):
    def styler(g):
        return Style(Font.MutatorSans(), 200,
            wdth=at.ki(g.c).io(8),
            wght=at.ki("W").io(8)
            )

    return (Glyphwise("RUOHO", styler)
        .align(f.a.r)
        .f(1))

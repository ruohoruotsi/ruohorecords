from coldtype import *

@renderable((1080, 540))
def gw1(r):
    return (Glyphwise("GLYPHWISE\nRUOHO RECORDS", lambda g:
        Style(Font.MutatorSans(), 80,
            wght=g.e,
            wdth=g.e,
            rotate=g.e*10,
            fill=hsl(0.3+g.e*0.2, 0.7)))
        .align(r, ty=0)
        .lead(40)
        )
/*
*    geomerative example,
*    updated by ricard marxer
*
*    fjenett 20080417
*    fjenett 20081203 - updated to geomerative 19
*    ruoho ruotsi 20150107 - updated to smoothly unfurl
*/

import geomerative.*;

RFont font;
Boolean down = true;

void setup()
{
    size(1024, 400,FX2D);
    pixelDensity(2);  // fullScreen();
    smooth();
    
    RG.init(this);

    font = new RFont( "lucon.ttf", 112, RFont.CENTER);

    frameRate(5);
}

void draw()
{
    background(255);
    translate(width/2,height/2);
    
    RGroup grp = font.toGroup("rebeiro films");
  
    int maxFrames = 50;
    int multiplier = 1;
    int seglenA = frameCount % maxFrames;
  
    if (seglenA == 0) down = !down;  
    if(down) {
      RCommand.setSegmentLength(seglenA * multiplier);
    } else {   
      RCommand.setSegmentLength((maxFrames - seglenA) * multiplier);
    }
    
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    System.out.println(seglenA);

    RPoint[] pnts = grp.getPoints();

    ellipse(pnts[0].x, pnts[0].y, 5, 5);
    for ( int i = 1; i < pnts.length; i++ )
    {
        line( pnts[i-1].x, pnts[i-1].y, pnts[i].x, pnts[i].y );
        ellipse(pnts[i].x, pnts[i].y, 5, 5);
    }
}
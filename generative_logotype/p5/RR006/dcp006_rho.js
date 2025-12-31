// let COLS = createCols("https://coolors.co/eb300f-fe7688-fff566-212121-306e42-0d3b66"); // orig
// let COLS = createCols("https://coolors.co/000000-2f1000-621b00-945600-c75000"); // brown
// let COLS = createCols("https://coolors.co/palette/e89005-ec7505-d84a05-f42b03-e70e02") // Fiyah
// let COLS = createCols("https://coolors.co/palette/6e0d25-ffffb3-dcab6b-774e24-6a381f") // Golden Fields
// let COLS = createCols("https://coolors.co/palette/ffd289-facc6b-ffd131-f5b82e-f4ac32") // Citron

// JA is the winner palette for RR006
let COLS = createCols("https://coolors.co/8ea604-f5bb00-ec9f05-d76a03-bf3100"); // JA

let PALETTE;

// -----------------------------------------------------------------
var multiplier = 1;
var canvasSize_w = 1500;  // 1080p at retina // 1920×1080 
var canvasSize_h = 1500 * multiplier;  // 1080p at retina // 1920×1080 

function setup() {
  	createCanvas(canvasSize_w, canvasSize_h);
	background(240);
	frameRate(0.25);
}

function draw() {
	PALETTE = shuffle(COLS, true);
	// background(PALETTE[3]);
	PALETTE = PALETTE.slice(0, 3);
	
	rectMode(CENTER);

	pattern(PTN.stripePolygon(int(random(4, 10)),  int(random(8, 15))));
	// pattern(PTN.stripe(60 / int(random(6, 12))));

	//pattern(PTN.stripeCircle(60 / int(random(6, 12))));
	// pattern(PTN.stripeRadial(TAU /  int(random(60, 80))));

	console.log(TAU)
	rectPattern(0, 0, windowWidth*2, windowHeight*2);
	
	// rho 
	rho( width - width / 2, 
		 height / 3, 
		 width / 2, 
		 height, 
		 true);
}

function rho(cx, cy, w, h, rho_shape)
{
	const structure = rho_shape ? 
				[[-9, -9],[-9, -9],[0, 1],[-1, -1], [-1, 2], [-1, -9],[2, -9]] :
				[[-1, 2],[-1, -9],[3, 1],[-9, -1], [0, 2], [-9, -9],[-9, -9]] ;

	const xNum = structure[0].length;
	const xSpan = w / xNum;
	const yNum =  structure.length;
	const ySpan = h / yNum;
	
	rectMode(CENTER);
	ellipseMode(CENTER);
	
	push();
	translate(cx - w /2, cy - h / 2);
	
	for(let yi = 0; yi < yNum; yi++)
	{
		for(let xi = 0; xi < xNum; xi++)
		{
			const isDraw = structure[yi][xi];
			if(isDraw >= -1)
			{
				const x = xSpan * (xi + 0.5);
				const y = ySpan * (yi + 0.5);
				
				patternColors(shuffle(PALETTE));
				pattern(randPattern(xSpan));
				patternAngle(int(random(4)) * PI / 4);
				push();
				translate(x, y);
				if(isDraw == 0 || isDraw > 1){
					rotate(isDraw * HALF_PI);
					rectPattern(0, 0, xSpan, ySpan, xSpan, 0, 0, 0);
				}
				else if(isDraw == 1) {					      

				  // --- Mirrored, upper left shape
				  push(); // Save coordinate system
				  scale(-1, 1); // Flip horizontally
				  
				  // arcPattern(xSpan / 2, ySpan / 2, xSpan * 2, ySpan * 2, PI, TAU / 4 * 3);
				  rectPattern(0, 0, xSpan, ySpan, xSpan, 0, 0, 0);

				  pop(); // Restore coordinate system
				}
				else
				{
					rectPattern(0, 0, xSpan, ySpan);
				}
				pop();
			}
		}
	}
	pop();
}
function randPattern(t)
{
	const ptArr = [
		// PTN.noise(0.5),
		PTN.stripeRadial(TAU /  int(random(2, 90))),
		PTN.noiseGrad(0.4),
		PTN.stripe(t / int(random(30, 120))),
		PTN.stripeCircle(t / int(random(6, 12))),
		PTN.stripePolygon(int(random(3, 10)),  int(random(6, 12))),
		PTN.stripeRadial(TAU /  int(random(6, 50))),
		PTN.wave(t / int(random(1, 3)), t / int(random(10, 20)), t / 5, t / 10),
		PTN.dot(t / 10, t / 10 * random(0.2, 1)),
		PTN.checked(t / int(random(15, 40)), t / int(random(15, 40))),
		PTN.cross(t / int(random(10, 40)), t / int(random(40, 60))),
		PTN.triangle(t / int(random(5, 10)), t / int(random(5, 10)))
	]
	return random(ptArr);
}


function createCols(url)
{
	let slaIndex = url.lastIndexOf("/");
	let colStr = url.slice(slaIndex + 1);
	let colArr = colStr.split("-");
	for(let i = 0; i < colArr.length; i++)colArr[i] = "#" + colArr[i];
	return colArr;
}

function customPatternFuncGen(_span, _dia)
{
	const customFunc = function(_w, _h)
	{
		ellipseMode(CENTER);
		rectMode(CORNER);

		const c = patternColors();
		const span = _span;
		const dia = _dia;

		fill(c[0]);
		rect(0, 0, _w, _h);
		c.shift();

		for(let y = 0; y <= _h; y += _span)
			for(let x = 0; x <= _w; x += _span)
			{
				fill(random(c));
				ellipse(x, y, _dia, _dia);
			}
	}	
	return customFunc;
}

function keyPressed() {
  if (key == 's' || key == 'S') 
    saveCanvas(Math.round(new Date().getTime() / 1000).toString(), 'png');
}

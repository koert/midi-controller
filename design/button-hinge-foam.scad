capOuterWidth = 20;
capOuterHeight = 7;
buttonMargin = 2;
holeRadius = 5/2;
holeHeight = 2.5;
wallThickness = 1;
tightMargin = 0.5;
margin = 1;
foamWidth = 5;
foamHeight = 1.0;

module capTop() {
  $fn = 30;
  innerWidth = capOuterWidth - wallThickness*2 - tightMargin;
  ceilingHeight = holeHeight;
  //translate([0, 0, capOuterHeight/2])
  union() {
    translate([0, 0, ceilingHeight/2+wallThickness/2])
    cube([capOuterWidth, capOuterWidth-wallThickness/2, wallThickness], center=true);
    translate([0, 0, 0])
    difference() {
      cube([innerWidth, innerWidth-wallThickness/2, ceilingHeight], center=true);
      translate([0, 0, holeHeight-margin/2-ceilingHeight])
      cylinder(h = holeHeight+margin, r = holeRadius, center = true);
    }
  }
}


module inner(innerWidth) {
  union() {
    translate([0, 0, 0])
    cube([innerWidth, innerWidth, capOuterHeight+margin], center=true);

    translate([0, 0, -capOuterHeight+wallThickness*2])
    cube([capOuterWidth*0.75, capOuterWidth+wallThickness*5, capOuterHeight], center=true);
    translate([0, 0, -capOuterHeight+wallThickness*2])
    cube([capOuterWidth+wallThickness*5, capOuterWidth*0.75, capOuterHeight], center=true);
  }
}


module grid() {
  $fn = 30;
  buttonGridSize = capOuterWidth + buttonMargin*2;
  gridWidth = buttonGridSize * 2;
  gridHeight = buttonGridSize * 2;
  innerWidth = capOuterWidth + margin;
  ceilingHeight = holeHeight + wallThickness;
  union() {
	  translate([0, 0, capOuterHeight/2])
	  difference() {
	    translate([0, 0, 0])
	    cube([gridWidth, gridWidth, capOuterHeight], center=true);
	
	    translate([-buttonGridSize/2, buttonGridSize/2, 0])
	    inner(innerWidth);
	    translate([buttonGridSize/2, buttonGridSize/2, 0])
	    inner(innerWidth);
	    translate([-buttonGridSize/2, -buttonGridSize/2, 0])
	    inner(innerWidth);
	    translate([buttonGridSize/2, -buttonGridSize/2, 0])
	    inner(innerWidth);
	 }

    translate([-buttonGridSize/2, buttonGridSize/2, 0])
    capBottom();

    translate([buttonGridSize/2, buttonGridSize/2, 0])
    capBottom();

    translate([-buttonGridSize/2, -buttonGridSize/2, 0])
    capBottom();

    translate([buttonGridSize/2, -buttonGridSize/2, 0])
    capBottom();
 }
}

module capBottom() {
  $fn = 30;
  size = capOuterWidth-tightMargin;
  innerWidth = capOuterWidth - wallThickness*2;
  height = capOuterHeight - wallThickness - tightMargin;
  translate([0, 0, capOuterHeight-height/2])
  difference() {
    union() {
      translate([0, -size/2, -height/2])
      rotate(a = [90, 0, 90])
      linear_extrude(height = size, center = true)
      polygon([[0,height/4],[size,0],[size,height], [wallThickness, height]], convexity = N);

      translate([0, capOuterWidth/2, -height/2+wallThickness/2])
      cube([capOuterWidth, wallThickness*2, wallThickness], center=true);
    }
    translate([0, wallThickness/2, 0])
    cube([innerWidth, innerWidth-wallThickness/2, height+margin], center=true);
  }
}

intersection() {
//translate([-3, -3, 0])
//cube([capOuterWidth*1.5, capOuterWidth*1.5, capOuterHeight*2]);

translate([0, 0, 0])
grid();
}

*translate([0, 0, 20])
capTop();


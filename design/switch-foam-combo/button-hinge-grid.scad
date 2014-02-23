capOuterWidth = 20;
capOuterHeight = 7;
buttonMargin = 2;
holeRadius = 5/2;
holeHeight = 2.5;
wallThickness = 1;
tightMargin = 0.5;
margin = 1;

module capTop() {
  $fn = 30;
  innerWidth = capOuterWidth - wallThickness*2 - tightMargin;
  ceilingHeight = holeHeight;
  //translate([0, 0, capOuterHeight/2])
  union() {
    difference() {
      translate([0, 0, ceilingHeight/2+wallThickness])
      cube([capOuterWidth, capOuterWidth-wallThickness/2, wallThickness*2], center=true);

      translate([-capOuterWidth/2-tightMargin/2,0,ceilingHeight/2+wallThickness*4])
      rotate(a = [90,90,0])
      linear_extrude(height = capOuterWidth, center = true)
      polygon([[0,0],[wallThickness*4,0],[0, wallThickness*4]], convexity = N);

      translate([0,-capOuterWidth/2-tightMargin/2,ceilingHeight/2+wallThickness*4])
      rotate(a = [90,90,90])
      linear_extrude(height = capOuterWidth, center = true)
      polygon([[0,0],[wallThickness*4,0],[0, wallThickness*4]], convexity = N);

      translate([capOuterWidth/2+tightMargin/2,0,ceilingHeight/2+wallThickness*4])
      rotate(a = [90,90,180])
      linear_extrude(height = capOuterWidth, center = true)
      polygon([[0,0],[wallThickness*4,0],[0, wallThickness*4]], convexity = N);

      translate([0,capOuterWidth/2+tightMargin/2,ceilingHeight/2+wallThickness*4])
      rotate(a = [90,90,270])
      linear_extrude(height = capOuterWidth, center = true)
      polygon([[0,0],[wallThickness*4,0],[0, wallThickness*4]], convexity = N);

    }
    translate([0, 0, 0])
    difference() {
      cube([innerWidth, innerWidth-wallThickness/2, ceilingHeight], center=true);
      translate([0, 0, holeHeight-margin/2-ceilingHeight-tightMargin])
      cylinder(h = holeHeight+margin, r = holeRadius, center = true);
    }
  }
}


module inner(innerWidth) {
  union() {
    *translate([0, 0, 0])
    cube([innerWidth, innerWidth, capOuterHeight+margin], center=true);

    translate([0, 0, wallThickness*2])
    cube([innerWidth, innerWidth, capOuterHeight+margin], center=true);

    translate([0, -wallThickness, 0])
    cube([innerWidth, innerWidth-wallThickness*2, capOuterHeight+margin], center=true);

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
      polygon([[0,0],[size+wallThickness*2,0],[size+wallThickness*2,wallThickness*2],[size,wallThickness*2],[size,height], [wallThickness/2, height]], convexity = N);
    }
    translate([0, wallThickness/4, 0])
    cube([innerWidth, innerWidth-wallThickness/2, height+margin], center=true);
  }
}

*intersection() {
//translate([5, -5, 0])
//cube([capOuterWidth*1.5, capOuterWidth*1.5, capOuterHeight*2]);

translate([0, 0, 0])
grid();
}

translate([0, 0, 20])
capTop();


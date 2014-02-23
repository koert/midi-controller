capOuterWidth = 20;
capOuterHeight = 7;
holeRadius = 3.5/2;
holeHeight = 2.5;
wallThickness = 1;
tightMargin = 0.5;
margin = 1;

module cap() {
  $fn = 30;
  innerWidth = capOuterWidth - wallThickness;
  ceilingHeight = holeHeight + wallThickness;
  translate([0, 0, capOuterHeight/2])
  difference() {
    translate([0, 0, 0])
    cube([capOuterWidth, capOuterWidth, capOuterHeight], center=true);
    translate([0, 0, -ceilingHeight])
    cube([innerWidth, innerWidth, capOuterHeight], center=true);
    translate([0, 0, capOuterHeight/2-ceilingHeight+holeHeight/2])
    cylinder(h = holeHeight+1, r = holeRadius, center = true);
  }
}

module capTop() {
  $fn = 30;
  innerWidth = capOuterWidth - wallThickness*2 - tightMargin;
  ceilingHeight = holeHeight;
  //translate([0, 0, capOuterHeight/2])
  union() {
    translate([0, 0, ceilingHeight/2+wallThickness/2])
    cube([capOuterWidth, capOuterWidth, wallThickness], center=true);
    translate([0, 0, 0])
    difference() {
      cube([innerWidth, innerWidth, ceilingHeight], center=true);
      translate([0, 0, holeHeight-margin/2-ceilingHeight])
      cylinder(h = holeHeight+margin, r = holeRadius, center = true);
    }
  }
}

module capBottom() {
  $fn = 30;
  innerWidth = capOuterWidth - wallThickness*2;
  height = capOuterHeight - wallThickness - tightMargin;
  translate([0, 0, capOuterHeight/2])
  difference() {
    union() {
      translate([0, 0, 0])
      cube([capOuterWidth, capOuterWidth, height], center=true);
      translate([0, 0, wallThickness/2])
      cube([capOuterWidth/2, capOuterWidth+wallThickness*2, wallThickness], center=true);
      translate([0, 0, wallThickness/2])
      cube([capOuterWidth+wallThickness*2, capOuterWidth/2, wallThickness], center=true);
    }
    translate([0, 0, 0])
    cube([innerWidth, innerWidth, height+margin], center=true);
  }
}

*rotate(a = [0, 180, 0])
cap();

translate([0, 0, 5])
rotate(a = [0, 180, 0])
capTop();

*translate([0, 0, -5])
capBottom();


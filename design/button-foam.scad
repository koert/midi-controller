outerSize = 20;
innerSize = 18;
topHeight = 4;
baseHeight = 5;
foamWidth = 5;
foamHeight = 1.0;
spaceY = 2;
thickness = 1;
margin = 1.2;
tightMargin = 0.5;

module top() {
  $fn=100;
  $fs=1;
  translate([0, 0, baseHeight + spaceY])
  difference() {
    translate([0, 0, topHeight/2])
    cube([outerSize, outerSize, topHeight], center=true);
    translate([0, 0, topHeight/2-thickness])
    cube([innerSize, innerSize, topHeight], center=true);
  }

}

module base() {
  $fn=100;
  $fs=1;
  translate([0, 0, baseHeight/2])
  difference() {
    translate([0, 0, 0])
    cube([outerSize, outerSize, baseHeight], center=true);
    translate([0, 0, 0])
    cube([innerSize, innerSize, baseHeight+1], center=true);
  }

}

module buttonTop() {
  $fn=100;
  $fs=1;
  innerHeight = baseHeight - foamHeight - tightMargin;
  translate([0, 0, thickness])
  union() {
    translate([0, 0, thickness/2])
    cube([outerSize, outerSize, thickness], center=true);
    translate([0, 0, -innerHeight/2])
    cube([innerSize-tightMargin, innerSize-tightMargin, innerHeight], center=true);
  }
}

module buttonBottom() {
  $fn=100;
  $fs=1;
  height = baseHeight;
  innerHeight = baseHeight - foamHeight + margin;  
  translate([0, 0, 0])
  difference() {
    union() {
      translate([0, 0, baseHeight/2])
      cube([outerSize, outerSize, baseHeight], center=true);
      translate([0, 0, thickness+thickness/2])
      cube([outerSize/2, outerSize+thickness, thickness], center=true);
      translate([0, 0, thickness+thickness/2])
      cube([outerSize+thickness, outerSize/2, thickness], center=true);
    }
    translate([0, innerSize/2-foamWidth/2, height/2])
    cube([innerSize, foamWidth, height+thickness+1], center=true);
    translate([0, -innerSize/2+foamWidth/2, height/2])
    cube([innerSize, foamWidth, height+thickness+1], center=true);
    translate([0, 0, height/2])
    cube([innerSize, innerSize-foamWidth*2-thickness*2, height+thickness+1], center=true);
    translate([0, 0, innerHeight/2+foamHeight])
    cube([innerSize, innerSize, innerHeight+0.01], center=true);
  }

}

module buttonMountInner(innerWidth, width, height) {
  innerWidth2 = innerWidth + thickness + margin;
    union() {
	    translate([0, 0, height/2])
	    cube([innerWidth, innerWidth, height+1], center=true);
	    #translate([0, 0, thickness*2])
	    cube([innerWidth2, outerSize/2 + margin, thickness*4], center=true);
	    translate([0, 0, thickness*2])
	    cube([outerSize/2 + margin, innerWidth2, thickness*4], center=true);
	    translate([0, 0, thickness-0.5])
	    cube([innerWidth-thickness*2, width+1, thickness*2], center=true);
	    translate([0, 0, thickness-0.5])
	    cube([width+1, innerWidth-thickness*2, thickness*2], center=true);
    }
}

module buttonMount() {
  width = outerSize + thickness*6;
  spacing = 2.0;
  totalWidth = outerSize*2 + spacing*4;
  height = baseHeight;
  innerWidth = outerSize + margin;
  innerWidth2 = outerSize + thickness*2 + margin;
  translate([0, 0, -thickness*4])
  difference() {
    translate([0, 0, height/2])
    cube([totalWidth, totalWidth, height], center=true);

    translate([outerSize/2+spacing, outerSize/2+spacing, 0])
    buttonMountInner(innerWidth, width, height);

    translate([-outerSize/2-spacing, outerSize/2+spacing, 0])
    buttonMountInner(innerWidth, width, height);

    translate([outerSize/2+spacing, -outerSize/2-spacing, 0])
    buttonMountInner(innerWidth, width, height);

    translate([-outerSize/2-spacing, -outerSize/2-spacing, 0])
    buttonMountInner(innerWidth, width, height);
  }
}

module bottomSupport() {
  $fn = 30;
  difference() {
    cylinder(h = 8, r1 = 3.5, r2 = 2.5, center = true);
    cylinder(h = 9, r = 1.2, center = true);
  }
}

*top();
*base();

*buttonTop();

*translate([0, 0, -10])
buttonBottom();

*translate([45, 0, -10])
buttonMount();

translate([0, 0, -10])
bottomSupport();


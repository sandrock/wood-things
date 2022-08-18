
// 
// Tablette pour écrans à poser sur une table
// Screen tablet to put on a table
// 
// Author:         sandrock@sandrock.fr
// Public license: none
// Copyright:      sandrock, all rights reserved
// 

// input variables
// suffixes are T̲hickness, L̲ength, H_eight, R_adius
// millimeters

// table configuration
tableX =       1500; // mm. table length
tableY =       750;  // mm. table deepness
tableT =       40;   // mm. tabletop thixkness
tableH =       800;  // mm. table height
tableFootR =   25;   // mm. table feet radius

// tablet configuration
tabletX = tableX;
tabletY =      400; // mm. tablet deepness
tabletT =      20;  // mm. tablet parts thickness
tabletH =      100+tableT; // mm. tablet height (under)

// view configuration
// how much to explode the parts?
explode =      0; // [0:0.05:1]
showTable =    1; // [0,1]
explodeL =     200; // mm

groundColor = [070/255, 070/255, 070/255, 0.75];

// draw ground
color(groundColor)
translate([-tableX, -tableX*1.5, 0])
%square(tableX*3, false);

// draw table
if (showTable) {
  translate([0, 0, -3]) {
    drawTable();
  }
}

// draw tablet
translate([0, 0, tableH]) {
    translate([0, 0, explode * explodeL]) {
        drawTablet();
    }
}


module drawTablet() {
    // top
    translate([0, tableY-tabletY, tabletH-tabletT]) 
    cube([tabletX, tabletY, tabletT]);

    // back
    translate([0, tableY-tabletT, 0]) 
    explode(0, 1, -.2)
    cube([tabletX, tabletT, tabletH-tabletT]);

    // side 1
    let(sideL = tabletY*.9)
    translate([tabletT, tableY-tabletT-sideL, 0]) 
    rotate(90, [0,0,1])
    explode(0, 1, -.2)
    cube([sideL, tabletT, tabletH-tabletT]);

    // side 1
    let(sideL = tabletY*.9)
    translate([tableX, tableY-tabletT-sideL, 0]) 
    rotate(90, [0,0,1])
    explode(0, -1, -.2)
    cube([sideL, tabletT, tabletH-tabletT]);

    // TODO: round top edges
    // TODO: top holes
    // TODO: bottom holes
    // TODO: screws
}

module drawTable() {
    color("#bfb493") {
        // top
        translate([0, 0, tableH-tableT]) 
        cube([tableX, tableY, tableT]);

        // feet
        translate([tableFootR*4, tableFootR*4, 0]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
        translate([tableX-tableFootR*4, tableFootR*4, 0]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
        translate([tableFootR*4, tableY-tableFootR*4, 0]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
        translate([tableX-tableFootR*4, tableY-tableFootR*4, 0]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
    }
}


module explode(x, y, z) {
    let (v = explode * explodeL)
        translate([x * v, y * v, z * v])
            children();
}



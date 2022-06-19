
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

// table configuration

tableX =       1500; // mm
tableY =       750;  // mm
tableT =       40;   // mm
tableH =       800;  // mm
tableFootR =   25;   // mm

// tablet configuration

tabletX = tableX;
tabletY =      400; // mm
tabletT =      20; // mm
tabletH =      100+tableT; // mm

// view configuration
// how much to explode the parts?
explode =      0; // [0:0.05:1]
showTable =    1; // [0,1]
explodeL =     200; // mm

if (showTable) {
  drawTable();
}

translate([0, 0, explode * explodeL]) 
    drawTablet();


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


}

module drawTable() {
    // top
    color("#bfb493") {
        translate([0, 0, -tableT]) 
        cube([tableX, tableY, tableT]);

        // feet
        translate([tableFootR*4, tableFootR*4, -tableH]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
        translate([tableX-tableFootR*4, tableFootR*4, -tableH]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
        translate([tableFootR*4, tableY-tableFootR*4, -tableH]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
        translate([tableX-tableFootR*4, tableY-tableFootR*4, -tableH]) 
        cylinder(tableH-tableT, tableFootR, tableFootR);
    }
}


module explode(x, y, z) {
    let (v = explode * explodeL)
        translate([x * v, y * v, z * v])
            children();
}




// 
// Coffret et présentoir pour flèches
// Box    and display    for  arrows
// 
// Author:         sandrock@sandrock.fr
// Public license: none
// Copyright:      sandrock, all rights reserved
// 

// input variables
// suffixes are T̲hickness, L̲ength
insideX =      900; // mm
insideY =      320; // mm
insideZ =      050; // mm
baseX =        insideX;
baseY =        insideY;
fondT =        4; // mm
sideT =        18; // mm
baseExtraX =   5;  // mm. how much the thin back penetratres into the side planks
baseExtraZ =   10; // mm. how much distance between the back and the ground
explodeL =     40; // mm
topRotate =    45; // [0:180]
arrowFletchL = 300; // mm
arrowHeadL =   170; // mm
arrowT =       9.5; // mm
brown1 =       [142/255, 124/255, 64/255, .7];
brown2 =       [130/255, 108/255, 37/255, .7];
brown3 =       [096/255, 084/255, 45/255, .7];
customTime =   -0.5; // [-0.5:0.5:1.0]

// intermediate variables
frontH = insideZ + baseExtraZ;

// bottom part
set(arrowRadius = 20);

// top part (rotated)
if (customTime >= 0) {
    translate([0, insideY , insideZ+20]) 
        explode(0, 4, 0)
        rotate([topRotate, 0, 0]) 
        translate([0, 0, insideZ*-1]) 
        set(arrowRadius = 25);
}

module set(arrowRadius = 25) {
    // base du fond bas
    color(brown1)
    translate([0, 0, -fondT])
    cube([baseX, baseY, fondT]);

    // fond bas
    color(brown1)
    translate([-baseExtraX, -baseExtraX, -fondT])
    cube([baseX +2*baseExtraX, baseY +2*baseExtraX, fondT]);

    // front
    color(brown2)
    translate([-sideT, 0, -baseExtraZ])
    explode(0, -1, 0)
    rotate([90, 0, 0])
    plank(baseX + 2 * sideT, frontH);

    // back
    color(brown2)
    translate([-sideT, baseY + sideT, -baseExtraZ])
    explode(0, +1, 0)
    rotate([90, 0, 0])
    plank(baseX + 2 * sideT, frontH);

    // left
    color(brown3)
    translate([-sideT, 0, -baseExtraZ])
    explode(-1, 0, 0)
    rotate([90, 0, 90])
    plank(baseY, frontH);

    // right
    color(brown3)
    translate([baseX, 0, -baseExtraZ])
    explode(+1, 0, 0)
    rotate([90, 0, 90])
    plank(baseY, frontH);

    // back plate for leather thingy
    color(brown2)
    translate([baseX * 0.1, baseY + sideT + sideT/4 + sideT/3,  4*sideT/3])
    explode(0, +1, 0)
    rotate([90, 0, 0])
    cube([baseX * 0.8 , frontH/3, sideT/3]);

    // arrow fetching separator
    color(brown3)
    translate([arrowFletchL, 0, 0]) 
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrowPlank(insideY, 50, arrowRadius);

    // arrow head separator
    color(brown3)
    translate([insideX - arrowHeadL, 0, 0]) 
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrowPlank(insideY, 50, arrowRadius); 
}

module arrowPlank(x, y, radiusL){
    difference() {
        plank(x, y);

        for (i = [0:10]) {
            translate([radiusL + i*radiusL*2, y-radiusL, -0.5]) {

                scale(1.05) 
                cube([arrowT, frontH/2, sideT]);

                translate([arrowT/2, arrowT/2, 0]) {
                    translate([0, 0, -arrowFletchL/2]) 
                    %cylinder(arrowFletchL/3, radiusL, radiusL, center=false);

                    translate([0, 0, -sideT*10]) 
                    %cylinder(sideT*20, arrowT/2, arrowT/2, center=false);
                }
            }
        }
    }
}

module plank(x, y){
    cube([x, y, sideT]);
}


module explode(x, y, z) {
    let (v = xp())
        translate([x * v, y * v, z * v])
            children();
}

// this decides whether to use the animation time $t or the customizer time
function actualTime() =
    customTime >= 0 ? customTime : $t;

// make time 0 between 0.0-0.2 and 0.8-1.0
function smoothTime() = 
    let (t = actualTime())
    t <  .2 ? 0 :
    t >  .8 ? 0 :
    t <= .5 ? ( (t-.2)     *3) : 
              ((.3-(t-.5))*3);

// gets the explode distance from the actual time
function xp() = 
    let (t = smoothTime())
    smoothTime() * explodeL;

echo(str("$t=", $t, " smooth=", smoothTime(), " xp=", xp()));

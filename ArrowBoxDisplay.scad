
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
insideX = 900;
insideY = 320;
insideZ = 050;
baseX = insideX;
baseY = insideY;
fondT = 4;
sideT = 18;
baseExtraX = 5;  // how much the thin back penetratres into the side planks
baseExtraZ = 10; // how much distance between the back and the ground
explodeL = 40;
brown1 = [142/255, 124/255, 64/255, .7];
brown2 = [130/255, 108/255, 37/255, .7];
brown3 = [096/255, 084/255, 45/255, .7];
customTime = -0.5; // [-0.5:0.5:1.0]

// intermediate variables
frontH = insideZ + baseExtraZ;




// bas / base du fond bas
color(brown1)
translate([0, 0, -fondT])
#cube([baseX, baseY, fondT]);

// bas / fond bas
color(brown1)
translate([-baseExtraX, -baseExtraX, -fondT])
cube([baseX +2*baseExtraX, baseY +2*baseExtraX, fondT]);

// bas / front
color(brown2)
translate([-sideT, 0, -baseExtraZ])
explode(0, -1, 0)
rotate([90, 0, 0])
plank(baseX + 2 * sideT, frontH);

// bas / back
color(brown2)
translate([-sideT, baseY + sideT, -baseExtraZ])
explode(0, +1, 0)
rotate([90, 0, 0])
plank(baseX + 2 * sideT, frontH);

// bas / left
color(brown3)
translate([-sideT, 0, -baseExtraZ])
explode(-1, 0, 0)
rotate([90, 0, 90])
plank(baseY, frontH);

// bas / right
color(brown3)
translate([baseX, 0, -baseExtraZ])
explode(+1, 0, 0)
rotate([90, 0, 90])
plank(baseY, frontH);





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

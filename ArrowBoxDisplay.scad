
// 
// Coffret et présentoir pour flèches
// Box    and display    for  arrows
// 
// Author:         sandrock@sandrock.fr
// Public license: none
// Copyright:      sandrock, all rights reserved
// 

// animate with FPS=20 Step=50
// input variables
// suffixes are T̲hickness, L̲ength
// length is in millimeters 
insideX =      900; // mm. desired space inside box
insideY =      320; // mm. desired space inside box
insideZ =      050; // mm. desired space inside box
baseX =        insideX;
baseY =        insideY;
fondT =        4;  // mm. thickness of the back plate
sideT =        18; // mm. thickness of the side parts
baseExtraX =   5;  // mm. how much the back plate penetratres into the side parts
baseExtraZ =   10; // mm. how much distance between the back plate and the ground
explodeL =     80; // mm. during animation: how much to expand parts
topRotate =    45; // [0:180]
arrowSpaceForFletching = 300; // mm. length reserved for the fletching side of the arrow
arrowSpaceForHead =      170; // mm. length reserved for the head      side of the arrow
arrowT =       9.5; // mm. thickness of arrow shaft 
brown1 =       [142/255, 124/255, 064/255, .70];
brown2 =       [130/255, 108/255, 037/255, .70];
brown3 =       [096/255, 084/255, 045/255, .70];
debugColor =   [060/255, 084/255, 000/255, .35];
arrowColor =   [000/255, 084/255, 080/255, .55];
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
    echo(str("DRAWING: set with arrowRadius=", arrowRadius))

    // base du fond bas
    color(brown1)
    translate([0, 0, -fondT])
    *cube([baseX, baseY, fondT]);

    // fond bas
    backPlate = [ baseX +2*baseExtraX, baseY +2*baseExtraX, fondT ];
    color(brown1)
    translate([-baseExtraX, -baseExtraX, -fondT])
    cube(backPlate);
    echo(str("PART: back plate: ", backPlate));

    // front
    frontPartX = baseX + 2 * sideT;
    color(brown2)
    translate([-sideT, 0, -baseExtraZ])
    explode(0, -1, 0)
    rotate([90, 0, 0])
    plank(frontPartX, frontH);
    echo(str("PART: front part: [", frontPartX, ", ", sideT, ", ", sideT, "]"));

    // back
    color(brown2)
    translate([-sideT, baseY + sideT, -baseExtraZ])
    explode(0, +1, 0)
    rotate([90, 0, 0])
    plank(frontPartX, frontH);
    echo(str("PART: back  part: [", frontPartX, ", ", sideT, ", ", sideT, "]"));

    // left
    color(brown3)
    translate([-sideT, 0, -baseExtraZ])
    explode(-1, 0, 0)
    rotate([90, 0, 90])
    plank(baseY, frontH);
    echo(str("PART: left  part: [", baseY, ", ", frontH, ", ", sideT, "]"));

    // right
    color(brown3)
    translate([baseX, 0, -baseExtraZ])
    explode(+1, 0, 0)
    rotate([90, 0, 90])
    plank(baseY, frontH);
    echo(str("PART: right part: [", baseY, ", ", frontH, ", ", sideT, "]"));

    // back plate for leather thingy
    leatherPlate = [ baseX * 0.8 , frontH/3, sideT/3 ];
    color(brown2)
    translate([baseX * 0.1, baseY + sideT + sideT/4 + sideT/3,  4*sideT/3])
    explode(0, +1.5, 0)
    rotate([90, 0, 0])
    cube(leatherPlate);
    echo(str("PART: leather plate: ", leatherPlate));

    // arrow fetching separator
    color(brown3)
    translate([arrowSpaceForFletching, 0, 0]) 
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrowPlank(insideY, 50, arrowRadius);

    // arrow head separator
    color(brown3)
    translate([insideX - arrowSpaceForHead, 0, 0]) 
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrowPlank(insideY, 50, arrowRadius); 

    // arrows
    translate([000, 000, arrowT]) // elevate arrows a bit
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrows(insideY*1, insideX, arrowRadius);
}

module arrowPlank(x, y, radiusL){
    difference() {
        plank(x, y);

        // make holes for arrow shafts to fit in
        for (i = [0:10]) {
            translate([radiusL + i*radiusL*2, y-radiusL, -0.5]) {
                scale(1.05) 
                color(debugColor)
                cube([arrowT, frontH/2 - arrowT/2, sideT]);
            }
        }
    }
}

module arrows(x, y, radiusL){
    // x       is the length available to stack N arrows
    // y       is the length of one arrow
    // radiusL is the radius of one arrow
    arrowMargin = 20;
    arrowHeadLength = 40;
    arrowLength = y - arrowMargin - arrowMargin;
    arrowCount = floor(x / (2 * radiusL));

    echo(str("ARROWS: space=", y, "x", x, " arrow=", radiusL, " margin=", arrowMargin, " length=", arrowLength, " count=", arrowCount));

    // debug: draw one arrow box
    color(debugColor)
    *cube([radiusL*2, radiusL*2, y]);

    // draw many arrows
    for (i = [0:arrowCount-1]) {
        //         spreads arrows         elevate   nop
        translate([radiusL + i*radiusL*2, radiusL, 00.0]) {
            color(arrowColor)
            scale(1.00) // TODO: why did I scale to 1.05???
            translate([arrowT/2, arrowT/2, 20]) {
                // fût/shaft
                //translate([0, 0, -sideT*10]) 
                //#cylinder(sideT*40, arrowT/2, arrowT/2, center=false);
                %cylinder(arrowLength - arrowHeadLength, arrowT/2, arrowT/2, center=false);

                // empennage/fletching
                translate([0, 0, 20])
                scale(.980) // avoid flething from touching each other
                %cylinder(arrowSpaceForFletching/3, radiusL, radiusL, center=false);

                // head
                translate([0, 0, arrowLength - arrowHeadLength]) 
                %cylinder(arrowHeadLength, arrowT/1, 0, center=false);
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

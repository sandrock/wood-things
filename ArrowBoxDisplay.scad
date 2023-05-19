
// 
// Coffret et présentoir pour flèches (XV)
// Box    and display    for  arrows  (XV)
// 
// Author:         sandrock@sandrock.fr
// Public license: none
// Copyright:      sandrock, all rights reserved
// 

// TODO: thing to keep arrows from falling
// TODO: two leather belts to close the box
// TODO: 

// animate with FPS=20 Step=50
// input variables
// suffixes are T̲hickness, L̲ength
// length is in millimeters 
// origin is the left front corner of the inside of the box
insideX =      900; // mm. desired space inside box
insideY =      320; // mm. desired space inside box
insideZ =      060; // mm. desired space inside box
baseX =        insideX;
baseY =        insideY;
fondT =        18; // mm. thickness of the back plate
sideT =        18; // mm. thickness of the side parts
legL =         25; // mm. extra length for the side parts to serve as legs
baseExtraX =   00; // mm. how much the back plate penetratres into the side parts
baseExtraZ =   00; // mm. how much distance between the back plate and the ground
explodeL =     80; // mm. during animation: how much to expand parts
arrowSpaceForFletching = 250; // mm. length reserved for the fletching side of the arrow
arrowSpaceForHead =      250; // mm. length reserved for the head      side of the arrow
arrowT =       9.5; // mm. thickness of arrow shaft 

topRotate =    45; // [0:180]
globalAlpha = .99;

brown1 =       [140/255, 118/255, 037/255, globalAlpha]; // wood plates
brown2 =       [130/255, 108/255, 037/255, globalAlpha]; // wood fronts
brown3 =       [120/255, 098/255, 037/255, globalAlpha]; // wood sides
brown4 =       [110/255, 065/255, 015/255, globalAlpha]; // leather
darkGrey =     [050/255, 050/255, 050/255, globalAlpha]; // studs
debugColor =   [060/255, 084/255, 000/255, .35];
arrowColor =   [000/255, 084/255, 080/255, .55];
customTime =   -0.5; // [-0.5:0.5:1.0]

// intermediate variables
frontH = insideZ + fondT + baseExtraZ;

// log
echo(str(""));
echo(str("Arrow Box"));
echo(str("---------------"));
echo(str(""));
echo(str("Inside:  X=", insideX, " Y=", insideY, " Z=", insideZ));
echo(str("Outside: X=", (insideX+2*sideT), " Y=", (insideY+2*sideT)));
echo(str(""));

// bottom part
set(arrowRadius = 20, isBottom = true);

// top part (rotated)
rotationOffset = 40;
translate([0, insideY +rotationOffset , insideZ]) {

    // display center of rotation
    rotate([0, 90, 0]) 
    color(debugColor) 
    %cylinder(insideX, 2, 2);

    // other set
    if (customTime >= 0) {
        explode(0, 4, 0){
            rotate([topRotate, 0, 0]) {
                translate([0, rotationOffset, insideZ*-1]) {
                    // top part (rotated)
                    set(arrowRadius = 25, isBottom = false);

                    // leather binding base
                    translate([leatherBaseOffsetX, -sideT -leatherT, 0]) 
                    color(brown4)
                    cube([leatherBaseX, leatherT, leatherBaseY]);
                }
            }
        }
    }
}

// leather binding
leatherLengthRatio = 0.85;
leatherLengthOffset = (1 -leatherLengthRatio)/2;
leatherBaseX = insideX * leatherLengthRatio;
leatherBaseOffsetX = leatherLengthOffset * insideX;
leatherBaseY = 30;
leatherRotationY = 20;
leatherT = 4;
openingAngle = 1*(180 - topRotate);
translate([0, insideY +sideT, insideZ -leatherBaseY -leatherRotationY]) {

    // leather binding base
    translate([leatherBaseOffsetX, 0, 0]) 
    color(brown4)
    cube([leatherBaseX, leatherT, leatherBaseY]);

    // leather binding arc
    translate([leatherBaseOffsetX, leatherRotationY*2, 0 +leatherBaseY]) {
        
        rotate([0, 90, 0]) {

            extraAngle = atan(leatherRotationY/rotationOffset);
            totalAngle = openingAngle +2*(extraAngle);
            echo(str("TotalAngle = ", openingAngle, " + 2x ", extraAngle, " = ", totalAngle));
        
            rotate([0, 00, -90]) {

    // display center of rotation
    color(debugColor) 
    %cylinder(insideX, 2, 2);

                color(brown4)
                rotate_extrude(angle=-totalAngle) {
                    translate([leatherRotationY*2 -leatherT, 0, 0]) 
                    square([leatherT, insideX*leatherLengthRatio]);
                }

            }
        }
    }
}

module set(arrowRadius = 25, isBottom = false) {
    echo(str("DRAWING: set with arrowRadius=", arrowRadius));

    // back plate
    backPlate = [ baseX +2*baseExtraX, baseY +2*baseExtraX, fondT ];
    color(brown1)
    translate([-baseExtraX, -baseExtraX, -fondT])
    cube(backPlate);
    echo(str("PART: ", (isBottom ? "bottom" : "top   "), " back plate: ", backPlate));

    // front
    frontPartX = baseX + 2 * sideT;
    translate([-sideT, 0, -baseExtraZ -fondT])
    explode(0, -1, 0)
    rotate([90, 0, 0])
    frontPlank(frontPartX, frontH);
    echo(str("PART: ", (isBottom ? "bottom" : "top   "), " front part: [", frontPartX, ", ", frontH, ", ", sideT, "]"));

    // back
    translate([-sideT, baseY + sideT, -baseExtraZ -fondT])
    explode(0, +1, 0)
    rotate([90, 0, 180])
    translate([-frontPartX, 0, -sideT]) 
    frontPlank(frontPartX, frontH);
    echo(str("PART: ", (isBottom ? "bottom" : "top   "), " back  part: [", frontPartX, ", ", frontH, ", ", sideT, "]"));

    // left
    sideH = isBottom ? (frontH + legL) : frontH;
    translate([0, insideY, -sideH + insideZ])
    explode(-1, 0, 0)
    rotate([90, 0, 90+180])
    footPlank(baseY, sideH, isBottom, true);

    // right
    translate([baseX, 0, -sideH + insideZ])
    explode(+1, 0, 0)
    rotate([90, 0, 90])
    footPlank(baseY, sideH, isBottom, false);

    // back plate for leather thingy
    /*
    leatherPlate = [ baseX * 0.8 , frontH/3, sideT/3 ];
    color(brown2)
    translate([baseX * 0.1, baseY + sideT + sideT/4 + sideT/3,  4*sideT/3])
    explode(0, +1.5, 0)
    rotate([90, 0, 0])
    cube(leatherPlate);
    echo(str("PART: leather plate: ", leatherPlate));
    */

    // arrow fetching separator
    color(brown3)
    translate([arrowSpaceForFletching, 0, 0]) 
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrowPlank(insideY, 50, arrowRadius, isBottom, true);

    // arrow head separator
    color(brown3)
    translate([insideX - arrowSpaceForHead, 0, 0]) 
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrowPlank(insideY, 50, arrowRadius, isBottom, false); 

    // arrows
    translate([000, 000, arrowT]) // elevate arrows a bit
    explode(0, 0, 1)
    rotate([90, 0, 90])
    arrows(insideY*1, insideX, arrowRadius);
}

module arrowPlank(x, y, radiusL, isBottom, log) {
    difference() {
        plank(x, y);

        // make holes for arrow shafts to fit in
        maxArrows = floor(x / radiusL / 2) - 1;
        for (i = [0:maxArrows]) {
            if (log) {
                echo(str("ARROW: ", (isBottom ? "bottom" : "top   "), " i=", i, " index=", tx, "/", x));
            }
            tx = radiusL + i*radiusL*2;
            ty = y-radiusL;
            translate([tx, ty, -0.5]) {
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

module frontPlank(x, y, isBottom = false) {

    union() {

        color(brown2)
        plank(x, y);

        // studs
        vertSpacing = 22;
        horiSpacing = 80;

        // left+right studs
        leftCount  = floor(y / vertSpacing) - 1;
        leftOffset = floor(y % vertSpacing);
        for (i = [0:leftCount]) {
            // left
            translate([sideT/2, leftOffset + i * vertSpacing, sideT]) 
            stud();
            // right
            translate([sideT/2 + x - sideT, leftOffset + i * vertSpacing, sideT]) 
            stud();
        }

        // up+down studs
        topCount  = floor(x / horiSpacing) - 1;
        topOffset = floor(x % horiSpacing);
        for (i = [0:topCount]) {
            // up
            ////translate([topOffset + i * horiSpacing, sideT/2 + y - sideT, sideT]) 
            ////stud();
            // down
            translate([topOffset + i * horiSpacing, sideT/2, sideT]) 
            stud();
        }
    }
}

module stud() {
    size = 5;
    length = 15;
    union() {
        // head
        difference() {
            color(darkGrey)
            sphere(size);

            translate([-size, -size, -size*2])
            cube(size * 2);
        }

        // nail
        color(darkGrey)
        translate([0, 0, -length])
        cylinder(length, size/10, size/3);
    }
}

module footPlank(x, y, isBottom = false, isLeft = false) {

    if (isBottom) {
        width = x + sideT + sideT;
        radius = width/2;
        offset = -radius + x*0.07;
        translate([-sideT, 0, 0])
        color(brown3)
        difference(){
            union() {
                // top to bottom part (above)
                translate([sideT, 0, 0])
                cube([x, y, sideT]);

                // side to side part (bellow)
                translate([0, 0, 0])
                cube([width, legL, sideT]);
            };

            translate([radius, offset, -0.04])
            cylinder(sideT*1.08, radius, radius, false);
        }
        echo(str("PART: bottom ", (isLeft ? "left" : "right"), " part: [", width, ", ", y, ", ", sideT, 
            "] r=", radius, " o=", offset));
    } else {
        width = x;
        color(brown3)
        plank(baseY, frontH);
        echo(str("PART: top    ", (isLeft ? "left" : "right"), " part: [", width, ", ", y, ", ", sideT, "]"));
    }

    // studs
    horiSpacing = 60;

    // up+down studs
    topCount  = floor(x / horiSpacing) - 1;
    topOffset = floor(x % horiSpacing);
    position = isBottom ? (legL + sideT/2) : (sideT/2);
    for (i = [0:topCount]) {
        // down
        translate([topOffset + i * horiSpacing, position, sideT]) 
        stud();
    }
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











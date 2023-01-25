// switch D2F-01L2-D with big roller 5mm dia
// https://omronfs.omron.com/en_US/ecb/products/pdf/en-d2f.pdf

// prusa this logic in its original IR filament sensor
// sensor OUT:
// 0 (LOW)  filament inserted
// 1 (HIGH) filament runout

// MK2S 10-pin connector looking at PCB pins
// ---------
// x x x x x
// - s x - +
// ---------
// -=GND, +=+5V, s=signal

// MK3 10-pin connector looking at PCB pins, notch on top
// ---   ---
// x x x x x
// s x x - +
// ---------
// -=GND, +=+5V, s=signal

// switch pinout, button on top left
//  _-___
// |_____|
//  N O C
//
//  N-O : NO (normally open)
//  N-C : NC (normally closed)

// connect bare switch
// - O
// + C
// s N

adjust_click = 0.2; // to reliably click move +:closer -:away from filament
filament_hole_d = 2.4; // 1.75mm should freely passthru

module switch()
{
  swbox = [6.5,12.7,5.7];
  hole_pos = [[5,3],[5,-3.5],[5,-3.8]];
  hole_dia = 2;
  roller = [5,4]; // dxh
  roller_pos = [[-6.3,12.7/2,0],[-4.5,12.7/2+0.2,0]];
  // body
  difference()
  {
    translate([swbox[0]/2,0,0])
      cube(swbox, center=true);
    // holes
    for(i=[0,1,2])
    {
      translate(hole_pos[i])
        cylinder(d=hole_dia,h=swbox[2]+1,$fn=12,center=true);
    }
  }
  // roller
  for(i=[0,1])
    translate(roller_pos[i])
      cylinder(d=roller[0],h=roller[1],$fn=32,center=true);
}

module filament()
{
  translate([0,0,0])
    rotate([90,0,0])
    cylinder(d=1.75,h=70,$fn=12,center=true);
}

module filament_guide()
{
  difference()
  {
    union()
    {
      // guide block
      translate([0,2,0])
        cube([5,22,6],center=  true);
    }
    // roller cut
    translate([2,6.25,0])
    cylinder(d=6.3,h=10,$fn=32,center=true);
    // filament hole thru all
    rotate([90,0,0])
    {
      cylinder(d=filament_hole_d,h=50,$fn=12,center=true);
      // overhang fix
      translate([0,0.4,0])
        cylinder(d=filament_hole_d*0.8,h=50,$fn=12,center=true);
      // conical lead-in
      translate([0,0,8])
        cylinder(d1=filament_hole_d,d2=filament_hole_d*2,h=2.1,$fn=12,center=true);
      // conical lead-out
      if(1)
      translate([0,0,-12])
        cylinder(d2=filament_hole_d,d1=filament_hole_d*2,h=2.1,$fn=12,center=true);
    }
  }
}

module holder_sticks()
{
  sticks_h=2;
  sticks_pos=[[-8.5+13.5,3,-2],[-8.5+13.5,-3.6,-2]];
  for(i=[0,1])
    translate(sticks_pos[i])
      rotate([0,0,0])
        cylinder(d=1.8,h=sticks_h,$fn=12,center=true);
}

module holder_bars()
{
  // filament entry side
  translate([4+11.5-3,-7.8,0])
    cube([20,2.4,6],center=true);
  // filament exit side
  translate([4+11.5-3,11.8,0])
    cube([20,2.4,6],center=true);
  // switch side near roller
  translate([11.5,9.8,0])
    cube([6,6.4,6],center=true);
  // holds pcb filament entry side
  translate([20,-4.6,0])
    cube([5,4,6],center=true);
  // holds pcb filament exit side
  translate([20,8.6,0])
    cube([5,4,6],center=true);
}

module baseplate()
{
    translate([10,2,-1.5-6/2])
      cube([25,22,3],center=true);
}

module screw_holes()
{
  mounting_holes=[[4.5,-6],[11.5,10]];
     // mounting holes
  for(i=[0,1])
      translate(mounting_holes[i])
        rotate([0,0,90])
          cylinder(d=3,h=20,$fn=12,center=true);
}

connector_pcb_cube=[1.7,11,7.7];
connector_pcb_pos=[20,2.05,-0.84];

module connector_pcb(scl=[1,1,1])
{
  translate(connector_pcb_pos)
  scale(scl)
  cube(connector_pcb_cube,center=true);
  // connector front cut
  translate(connector_pcb_pos+[2,-0.1,0])
    cube([5,9.2,7],center=true);
}


scale([-1,1,1]) // mirror X-direction, cable on the left
{
switch_pos=[8-adjust_click,0,0]; // adjust X to reliably clock with filament inserted
translate(switch_pos)
  %switch();
%filament();
%connector_pcb();
filament_guide();
translate(switch_pos)
  holder_sticks();
difference()
{
  union()
  {
    filament_guide();
    baseplate();
    holder_bars();
  }
  screw_holes();
  connector_pcb();
}
}

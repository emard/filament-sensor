// filament sensor with magnet and HALL sensor

// prusa has this logic in its original IR filament sensor
// sensor OUT:
// 0 (LOW)  LOADED
// 1 (HIGH) EMPTY
// IR sensor pinout
// +  +5V
// O  OUT
// -  GND

// MK2S rambo13a 10-pin connector looking at PCB pins
// ---------
// x x x x x
// - s x - +
// ---------
// -=GND, +=+5V, s=signal

// MK3 einsy10a 10-pin connector looking at PCB pins
// ---   ---
// x x x x x
// s x x - +
// ---------
// -=GND, +=+5V, s=signal

// HALL sensor Honeywell SS495A, on package is written 95A
// pinout looking at pins, plastic case at the back
//   _______
//  / + - o \
//  ---------

// connect
//  - -
//  + +
//  s o

// Prusa MK2.5S firmware can be loaded to MK2S
// Support -> Sensor info
// Fil. sensor: 1-LOADED, 0-EMPTY

hall_pos = [0.5,0,6]; // adjust X value for triggering

hall_sensor_dim = [5,5,2];
//hall_sensor_dim = [4.06, 3.0, 1.6]*1.1; // Honeywell SS495A package, with enlarge factor for hole
filament_hole_d = 2.3; // 1.75mm should freely passthru

// the filament sensor cube dim
guide_dim=[25,16,8+3]; // reduce Z to see cross-section
guide_pos=[-2.5,0,1.5];

magnet2_pos = [-5,0,0]; // adjust X to tune force

connector_pcb_cube=[1.7,13,7.7];
connector_pcb_pos=[-12,0,9];


mounting_holes=[[-3,-5],[6,5],[-6,5]];

module hall_sensor()
{
  cube(hall_sensor_dim, center=true);
}

module magnet()
{
  cylinder(d=magnet_dim[0], h=magnet_dim[1], $fn=24, center=true);
}


module filament()
{
  translate([0,0,0])
    rotate([90,0,0])
    cylinder(d=1.75,h=70,$fn=12,center=true);
}

module roller_cutter(have_sensor=1)
{
  roller_pos = [2.0,-1,0];
  roller_dim = [6.0,5.4]; // DxH
  channel_angle = 38; // fall down angle
  channel_dim = [5,roller_dim[0],roller_dim[1]]; // from center of roller, at fall down angle
  top_insert_dim = [10,roller_dim[0]+0,roller_dim[1]];
  // roller cut
  translate(roller_pos)
  cylinder(d=roller_dim[0],h=roller_dim[1],$fn=32,center=true);
  // angular
  translate(roller_pos)
  rotate([0,0,-channel_angle])
  {
    // channel
    translate([channel_dim[0]/2,0,0])
    cube(channel_dim,center=true);
    // circular knee transition to upwards channel
    translate([channel_dim[0],0,0])
      cylinder(d=top_insert_dim[1],h=roller_dim[1],$fn=32,center=true);
    // cut upwards channel to insert magnet
    translate([channel_dim[0],0,0])
    rotate([0,0,-90+channel_angle])
    translate([top_insert_dim[0]/2,0,0])
    cube(top_insert_dim,center=true);
    // cut for sensor
    if(have_sensor>0.5)
    translate(hall_pos)
      //rotate([0,0,channel_angle])
      rotate([90,0,90+channel_angle/2])
      cube(hall_sensor_dim,center=true);
  }
}


module filament_guide()
{
  difference()
  {
    union()
    {
      // guide block
      translate(guide_pos)
        cube(guide_dim,center=true);
    }
    // main roller hole and sensor
    roller_cutter();
    // additional magnet to increase force
    translate(magnet2_pos) // more X distance less force
      scale([-1,1,1]) // mirror
        roller_cutter(have_sensor=0);
    // filament hole thru all
    rotate([90,0,0])
    {
      cylinder(d=filament_hole_d,h=50,$fn=12,center=true);
      // overhang fix
      if(0)
      translate([0.4,0,0])
        cylinder(d=filament_hole_d*0.8,h=50,$fn=12,center=true);
      // conical lead-in
      translate([0,0,-guide_pos[1]+2+guide_dim[1]/2-11+8])
        cylinder(d1=filament_hole_d,d2=filament_hole_d*2,h=2.1,$fn=30,center=true);
      // conical lead-out
      if(1)
      translate([0,0,-guide_pos[1]+2-guide_dim[1]/2+11-12])
        cylinder(d2=filament_hole_d,d1=filament_hole_d*2.08,h=2.1,$fn=30,center=true);
    }
  }
}

module holder_bars()
{
  // filament entry side
  holder_pos = guide_pos + [0,0,8.5];
  holder_dim = guide_dim - [0,0,5];
  holder_thick = 5;
  translate(holder_pos)
    difference()
    {
      cube(holder_dim,center=true);
      cube(holder_dim+[-holder_thick,-holder_thick,1],center=true);
    }
}

module baseplate()
{
    translate([10,2,-1.5-6/2])
      cube([25,22,3],center=true);
}



module screw_holes(d=3, h=30)
{
  // mounting holes
  for(i=[0,1,2])
      translate(mounting_holes[i])
        rotate([0,0,90])
          cylinder(d=d,h=h,$fn=12,center=true);
}

module connector_pcb()
{
  translate(connector_pcb_pos)
  cube(connector_pcb_cube,center=true);
  // connector front cut
  translate(connector_pcb_pos+[-2,0,0])
    cube([5,10,7],center=true);
}

// mounting spacer with connector cut and screw holes
module spacer()
{
   difference()
   {
     union()
     {
       holder_bars();
       translate([0,0,10])
       screw_holes(d=4,h=6);
     }
     screw_holes(d=1.8);
     translate([0,0,0.2])
     connector_pcb();
   }
}

// sensor
if(1)
rotate([-90,0,0])
{
%filament();
%connector_pcb();
difference()
{
  union()
  {
    filament_guide();
    //holder_bars();
  }
  connector_pcb();
  screw_holes();
}

%spacer();

}

// spacer
if(0)
{
  rotate([180,0,0])
  spacer();
}

frame_cube=[40.4,6.4,50];


snapon_points=[
 // bottom part near frame
 [-frame_cube[0]/2,frame_cube[1]/2],[-frame_cube[0]/2,-frame_cube[1]/2],
 // click notch slightly up
 [-frame_cube[0]/2+1,-frame_cube[1]/2],[-frame_cube[0]/2,-frame_cube[1]/2-2],
 // bottom edge
 [-25,-frame_cube[1]/2-2],[-25,9],
 // back side
 [25,9],[25,-9],
 // holder notch
 [15,-9],[15,-frame_cube[1]/2],[frame_cube[0]/2,-frame_cube[1]/2],
 // angled insertion helper
 [frame_cube[0]/2,frame_cube[1]/2+1],[15,frame_cube[1]/2]
 // insertion
];

extbar_points = [
  // go up
  [25,-9], [30,-9],
  // lean forward
  [60,-40], [110, -40],
  // back side return
  [110, -36], [61, -36],
  // return down
  [31,-5], [25,-5]
];

module frame()
{
  cube(frame_cube,center=true);
}

module mounting_holes_cutter()
{
  // [[4.5,-6],[11.5,10]];
  offset=[95,-40,-10];
  holes_pos=[[offset[0]+10,offset[1],offset[2]+4.5],[offset[0]-6,offset[1],offset[2]+11.5]];
  for(i=[0,1])
    translate(holes_pos[i])
      rotate([90,0,0])
      cylinder(d=1.8,h=20,$fn=12,center=true);
}

module snapon_clip()
{
  linear_extrude(30,center=true)
  polygon(points=snapon_points);
}

module snapon_clip_with_holes()
{
  difference()
  {
    union()
    {
      snapon_clip();
      extension_bar();
    }
    mounting_holes_cutter();
  }
}

module extension_bar()
{
  linear_extrude(30,center=true)
  polygon(points=extbar_points);
}

%frame();
snapon_clip_with_holes();

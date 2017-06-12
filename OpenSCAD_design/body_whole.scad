use <body_up.scad>
use <mount_down.scad>
use <moving_part.scad>
use <stepper_mount.scad>
include <constants.scad>
use <side_wall.scad>
use <enclosure_electronics.scad>
translate([0,0,162])rotate([180,0,0])body_up();
translate([0,0,4])stepper_mount();
translate([0,0,104])moving_part();
translate([0,0,88])rotate([180,0,0])mount_down();
translate([-3,0,-12/2])rotate([0,0,180])stepper_sidewall(L+6,12,2);
translate([-3,0,-20])rotate([0,0,180])body_down(L+6,W,8);
translate([-L/2-6,0,0])wall();
//translate([-10,0,-25]) enclosure();
include <constants.scad>
//linear_bearing();


module linear_bearing(){

// outer diameter in mm
outerD=BearingDiam;

// inner diameter in mm
innerD=RodDiam;

// height in mm
height=BearingHeight;

// amount of spikes
N = 20;

// width of shield in mm
shield = 1.5;

//resolution
res = 80;

/*[hidden]*/
d=outerD;
t=shield;
n=N;
id=innerD;
h=height;


$fn=res;

linear_extrude(height=h) 
difference() {
union() {
difference() {
circle(d=d);
circle(d=d-t*2);
}

a=360/n/2;

for (i=[1:1:n]) {


r=d/2-t/2;
rotate(a*2*(i-1))
polygon([[r,0],[0,0],[cos(a)*r,sin(a)*r]]);
}
}

circle(d=id);
}

}
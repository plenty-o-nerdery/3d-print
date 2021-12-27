include <roundedcube.scad>;

module drawerBin(dim, roundedRadius=4, x_divs=0, y_divs=0){
    difference(){
        corner(0, dim[2]+dim[3]) {
            corner(dim[1], dim[2]+dim[3]){
                union(){
                    difference(){
                        //53 for upper, make sure the pins fit
                        drawerShell(dim, roundedRadius);
                        translate([thick,thick,1])drawerShell([dim[0]-thick*2,dim[1]-thick*2,dim[2],dim[3]], roundedRadius);
                        //translate([thick,thick,1])roundedcube([dim[0]-thick*2,dim[1]-thick*2,dim[2]*2], false, roundedRadius, "zmin");
                    }
                    //add y dividers
                     if(y_divs > 0){
                        for (i=[1:y_divs]){
                            translate([0,i*dim[1]/(y_divs+1),0])y_divider(dim, roundedRadius);
                        }
                    }
                    //add x dividers
                    if(x_divs > 0){
                        for (i=[1:x_divs]){
                            translate([i*dim[0]/(x_divs+1),0,0])x_divider(dim, roundedRadius);
                        }
                    }
                }
            }   
        }
        //clip outside to original shape (helps with corners and dividers)
        difference(){
            translate([-10,-10,0])cube([500,500,500]);
            drawerShell(dim, roundedRadius);
        }
            
    }
}

module drawerShell(dim, roundedRadius){
    union(){
        roundedcube([dim[0], dim[1], dim[2]], false, roundedRadius, "zmin");
        translate([-thick,-thick,dim[2]-2]) roundedcube([dim[0]+1.5,dim[1]+1.5, dim[3]], false, roundedRadius, "zmin");
    }
}


module y_divider(dim, roundedRadius){
    //translate([0,dim[1]/2,0])
    rotate([0,0,-90])
    x_divider([dim[1], dim[0], dim[2], dim[3]], roundedRadius);
}

module x_divider(dim, roundedRadius){
    x_divider_internal(dim, roundedRadius, 1, "zmin");
    translate([0,-thick, dim[2]-2])x_divider_internal([dim[0], dim[1]+1.5, dim[3]], roundedRadius, 0, "z");
}
    
module x_divider_internal(dim, roundedRadius, dz, applyTo){
    difference(){
        x = roundedRadius*2+thick;
        translate([-x/2,0,0])cube([x, dim[1], dim[2]]);
        translate([thick/2,thick,dz])roundedcube([20, dim[1]-thick*2, dim[2]], false, roundedRadius, applyTo);
        translate([-20-thick/2,thick,dz])roundedcube([20, dim[1]-thick*2, dim[2]], false, roundedRadius, applyTo);
    }
    
}

module corner(dy=0, height){
    difference(){
        union(){
            children();
            translate([0,dy,0])cylinder(d=11,h=height);
        }
        translate([0,dy,-1])cylinder(d=10,h=height+2);
        
    }
}

thick = .75;
drawerBin([66,50,20,15], 4, x_divs=0, y_divs=2);  //20,15


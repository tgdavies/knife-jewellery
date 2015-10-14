$fn = 20;

bladef = "knife3-blade.dxf";
handlef = "knife3-handle.dxf";
hole_d = 1;
hole2_d = 0.65;
stock_h = 1.54;
handle_stock_h = 1.5;
hole_y = 24.4;
hole_x = 9;
hole_start = 58.706;
hole_end = 82.7;
hole_gap = (hole_end - hole_start)/2;

module blank(h = stock_h) {
rotate([0,0,-0.3]) {
translate(0,0,-stock_h/2) {
	linear_extrude(height = h, center = true, convexity = 2) {
		import( file = bladef );
	}
}
}}

module h_blank(h = handle_stock_h) {
rotate([0,0,-0.3]) {
translate(0,0,-stock_h/2) {
	linear_extrude(height = h, center = true, convexity = 1) {
		import( file = handlef );
	}
}
}
}

module hole(x,y, d = hole2_d) {
	translate([x,y,-stock_h/2]) {cylinder(r = d/2, h = stock_h + 0.1);}
}

module bevel() {
difference() {
	translate([6,10,0.9]) {rotate([3.0,-0.5,0.0]) {
		union() {
			rotate([-90,0,0]) {cylinder(r = 1, h = 20);}
			translate([0,-5,-1]) {cube([50,30,2]);}
		}
	} }
	translate([0,0,1]){handle(10);}
}
}

module holes() {
		hole(hole_start,17.506);
		hole(hole_start+hole_gap,17.542);
		hole(hole_end, 16.6, 1.0);

}

module tang(holes = true) {
	difference() {
		blank();
		bevel();
		if (holes) {
			holes();
		}
		scale([1,1,-1]) { bevel(); }
	}
}

module handle(holes = true) {
	difference() {
		h_blank(handle_stock_h);
		if (holes) {
			holes();
		}
	}
}

module knife(holes = true) {
	union() {
		tang(holes);
		translate([0,0,stock_h/2 + handle_stock_h/2]) { handle(holes); }
		translate([0,0,-stock_h/2 - handle_stock_h/2]) { handle(holes); }
	}
}

module cam_handle() {
	handle();
	translate([30,0,0]) { handle(); }
}



module box_cavity() {
	minkowski() {
		translate([-2, -25 + (box_w - box_corner_r) /2, 0]) {knife(false);}
		cylinder(r = 0.25, h = 0.5);
	}
}

box_h = 10;
box_w = 20;
box_l = 90;
box_corner_r = 3;

box_lip_h = 1;
box_lip_w = 2;

module box_blank() {
	translate([0, -box_w/2,0]) {
	hull() {
		translate([0,0,box_h - box_corner_r]) { sphere(r = box_corner_r); }
		translate([box_l - box_corner_r,0,box_h - box_corner_r]) { sphere(r = box_corner_r); }
		translate([0,box_w - box_corner_r,box_h - box_corner_r]) { sphere(r = box_corner_r); }
		translate([box_l - box_corner_r,box_w - box_corner_r,box_h - box_corner_r]) { sphere(r = box_corner_r); }

		translate([0,0,0]) { cylinder(r = box_corner_r, h = 1); }
		translate([box_l - box_corner_r,0,0]) { cylinder(r = box_corner_r, h = 1); }
		translate([0,box_w - box_corner_r,0]) { cylinder(r = box_corner_r, h = 1); }
		translate([box_l - box_corner_r,box_w - box_corner_r,0]) { cylinder(r = box_corner_r, h = 1); }
	}
}
}



module box_lip_blank(offset, h) {
	translate([0, -box_w/2,0]) {

	hull() {
		translate([offset,offset,0]) { cylinder(r = box_corner_r, h = h); }
		translate([box_l - box_corner_r - offset,offset,0]) { cylinder(r = box_corner_r, h = h); }
		translate([offset,box_w - box_corner_r - offset,0]) { cylinder(r = box_corner_r, h = h); }
		translate([box_l - box_corner_r - offset,box_w - box_corner_r - offset,0]) { cylinder(r = box_corner_r, h = h); }
	}
}
}

module box_lip(extra) {
	difference() {
		box_lip_blank(box_lip_w-extra, box_lip_h+extra);
		translate([0,0,-0.05]) {box_lip_blank(2 * box_lip_w + extra, box_lip_h + 0.1 + extra);}
	}
}

module box_top() {
	difference() {
		box_blank();
		translate([0,0,-0.05]) {box_lip(0.2);}
		box_cavity();
	}
}

module box_bottom() {
	difference() {
		union() {
			translate([0, box_w - box_corner_r]) {rotate([180,0,0]) {box_blank();}}
			box_lip(0);
		}
		box_cavity();
	}
}

module tangs_cam() {
	for (i = [0, 1, 2, 3, 4]) {
		translate([0, i * 12, 0]) {
			tang();
		}
	}
}


//box_cavity();
//box_top();
//box_bottom();
//tangs_cam();
//h_blank();

tang();
//cylinder(r = 1, h = 0.25);

//bevel();

//cam_handle();


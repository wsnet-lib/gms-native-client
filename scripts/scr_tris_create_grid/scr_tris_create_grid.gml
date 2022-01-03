// Create the trix boxes
function scr_tris_create_grid() {
	var margin = 10;
	var width = sprite_get_width(spr_tris_box) + margin;
	var height = sprite_get_height(spr_tris_box) + margin;	
	var xst = room_width/2 - width;
	var yst = room_height/1.7 - height;
	
	for (var yy=0; yy<3; yy++) {
		for (var xx=0; xx<3; xx++) {
			var box = instance_create_layer(xst+xx*width, yst+yy*height, "Instances", obj_tris_box);
			box.xpos = xx;
			box.ypos = yy;
			grid[xx][yy] = box;
		}
	}
}
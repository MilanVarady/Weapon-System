event_inherited();

var xx = x-lengthdir_x(sprite_width/2, direction);
var yy = y-lengthdir_y(sprite_height/2, direction);


part_emitter_region(global.pa_system_smoke, global.pa_emitter_smoke, xx, xx, bbox_top, bbox_bottom, 
					ps_shape_rectangle, ps_distr_linear);
					
part_emitter_burst(global.pa_system_smoke, global.pa_emitter_smoke, global.pa_type_smoke, 3);

// Game over
if (ex_x != undefined) {
	image_angle = direction;
	
	if (distance_to_point(ex_x, ex_y) < 16) {
		spd = 0;
		image_alpha = 0;
		
		createExplosion(ex_x, ex_y, 5, 0, noone, -200);
		
		with oGame {
			if (player_won == 0 xor player_won == 1) {
				if (player_won == 0) {
					player_exploded = 1;
				} else {
					player_exploded = 0;
				}
			}
		}
		
		instance_destroy();
	}
}
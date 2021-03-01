part_emitter_region(global.pa_system_square, global.pa_emitter_square, x, x, bbox_top, bbox_bottom, 
					ps_shape_rectangle, ps_distr_linear);
					
part_emitter_burst(global.pa_system_square, global.pa_emitter_square, global.pa_type_square, 1);

event_inherited();
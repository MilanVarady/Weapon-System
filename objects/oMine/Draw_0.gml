///@desc Rotate

if (!onground) {
	rot += 5;
	
	if (instance_exists(light_id)) instance_destroy(light_id);

} else {
	rot = 0;
	
	#region Light
	
	var lay = layer_get_id("lights");
	
	if (!instance_exists(light_id) and layer_exists(lay) and global.settings.graphics_lights and !grounded_prev) {
		// Create controller if not exists
		if (!instance_exists(obj_uls_controller)) {
			with instance_create_layer(0, 0, lay, obj_uls_controller) {
				image_blend = c_black;
				array_shadow_color[3] = 0;
			}
		}
		
		// Create light
		with instance_create_layer(x, bbox_top, lay, oMineLight) {
			image_blend = c_red;
			image_alpha = 0.3;
		
			light_initial_radius = 16;
			
			other.light_id = id;
		}
	}
	
	#endregion
}

draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, rot, c_white, 1);

grounded_prev = onground;
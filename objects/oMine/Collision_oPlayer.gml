///@desc Explode

if (other != my_player and onground) {
	createExplosion(x, y, 3, 100, oPlayer, layer_get_depth("weapons")-50);
	
	if (instance_exists(light_id)) instance_destroy(light_id);
	instance_destroy();
}
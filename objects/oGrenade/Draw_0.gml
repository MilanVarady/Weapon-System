if (global.settings.graphics_bullet_trail) event_inherited();

// Rotate
rot_angle -= hsp;

// Draw sprite
draw_sprite_ext(sGrenade, image_index, x, y, image_xscale, image_yscale, rot_angle, c_white, 1);


#region Set keys and gamepad

in = in_sys.check(global.gamepads_connected[player]);


weapon_input_pickup = in.pickup.pressed;
weapon_input_shoot = in.shoot.down;


#endregion

#region Movement

#region Reset vars

grav[1]				= grav[0];			// Gravity
move_spd_max[1]		= move_spd_max[0];	// Move speed
vsp_max[1]			= vsp_max[0];		// Max falling speed
vsp_min[1]			= vsp_min[0];		// Max acension speed
hsp_dec[1]			= hsp_dec[0];		// Hsp decelartion

acc[1]				= acc[0];			// Acceleration
dec[1]				= dec[0];			// Deceleration

jump_spd[1]			= jump_spd[0];		// Jump speed
jumps_max[1]		= jumps_max[0];		// Jumps you have

#endregion

#region Set flags

// Reset state
var num = stat.len;

for (var i = 0; i < num; i++) {
	state[i] = false;
}

move					= in.right.down + (in.left.down * -1);
dir						= hsp != 0 ? sign(hsp) : sign(image_xscale);
onwall					= place_meeting(x+1, y, wall) - place_meeting(x-1, y, wall);

#region Top free

var topfree = false;

if (onwall != 0) {
	for (var i = 0; i < top_check_h; i++) {
		var xx = x + (abs(sprite_width) * onwall);
		var yy = y - i;
	
		if (!place_meeting(xx, yy, wall)) {
			topfree = true;
			break;
		}
	}
}

#endregion

state[stat.ground]		= place_meeting(x,y+1, wall);
//state[stat.water]		= place_meeting(x, y, oWater);

state[stat.wall_slide]	= onwall != 0 and move == onwall and vsp > 0;
state[stat.top]			= topwall_enabled and out_of_control <= 0 and move == onwall and topfree and !state[stat.ground];
state[stat.air]			= !state[stat.ground] and onwall == 0 and !state[stat.water];

#endregion

#region Add modifiers + Wall slide

var num = stat.len;

for (var i = 0; i < num; i++) {
	if (state[i]) {
		grav[1]			*= m_grav[i];
		move_spd_max[1]	*= m_move_spd_max[i];
		jump_spd[1]		*= m_jump_spd[i];
		vsp_max[1]		*= m_vsp_max[i];
		vsp_min	[1]		*= m_vsp_min[i];
	}
}

#endregion

#region Acceleration/Deceleration

//if () {
	if (move != 0 and out_of_control <= 0) {
		// Acceleration

		
		// Keep momentum when changing dir
		if (keep_momentum and move != dir_prev) {
			move_spd = abs(move_spd) * move;	
		}
	
		// Add speed
		move_spd += acc[1] * move;
	
		// Keep in range
		move_spd = clamp(move_spd, -move_spd_max[1], move_spd_max[1]);
	} else {
		// Deceleration
		move_spd = approach(move_spd, 0, dec[1]);
	}
//} else {
//	move_spd = 0;	
//}

// Hsp deceleartion
if (out_of_control <= 0) public_hsp = approach(public_hsp, 0, hsp_dec[1]);

// Add grav
vsp += grav[1];
vsp = clamp(vsp, -vsp_min[1], vsp_max[1]);

#endregion

#region Jump/Wall Jump


#region Jump

// Jump/Input buffering
if (in.jump.pressed) {
	buffer_counter = buffer_max;
}

// If on ground set JUMPS TO MAX and COYOTE TIME
if (state[stat.ground]) {
	jumps = jumps_max[1];
	coyote_counter = coyote_max;
	jumped = false;
}


// If you fall off jumps--
if (coyote_counter == 0 and !jumped) {
	jumps--;
}

// Jump
if ((buffer_counter > 0) and ((jumps > 0) and ((coyote_counter > 0 and !jumped) or (jumps < jumps_max[1])))) {
		
	vsp = -jump_spd[1];
	jumps--;
	jumped = true;
	
	buffer_counter = 0;
	
	/* Jump sound
		audio_sound_pitch(snJump, random_range(0.8, 1.2));
		audio_play_sound(snJump, 5, false);
	*/
}



// Create Dust "particle"
if (state[stat.ground] and !was_grounded) repeat(5) {
	with (instance_create_layer(x,bbox_bottom,layer,oDust)) {
		vsp = 0;
	}
}



#endregion

#region Wall Jump

// Wall jump
var changed = change_time > 0 and move == change_dir and !state[stat.ground] ? true : false;
var walljump = onwall != 0 and !state[stat.ground] and in.jump.pressed ? true : false;

if (walljump_enabled and ((walljump) or (changed))) {
	var type = changed ? e_wj.normal : (state[stat.top] ? e_wj.top : e_wj.normal);
	
	out_of_control = walljump_delay_max;
	
	// Set multiplier
	var mult = changed ? change_dir : -onwall;
	
	public_hsp = wj_hsp[type] * mult;
	vsp = wj_vsp[type];
	
	jumps = jumps_max[1] - 1;
	
	if (state[stat.top]) {
		change_time = change_time_max;
		change_dir = onwall * -1;
	}
	
	if (changed) change_time = 0;
}

#endregion


#endregion

#region Water (swim up)

// Swim up
//if (touching(oWater) and in.jump.down) vsp = approach(vsp, -3, 0.2);

#endregion

#region Set hsp and dir

hsp = public_hsp + move_spd;

dir	= hsp != 0 ? sign(hsp) : sign(image_xscale);

#endregion

#region Collisions

/*
var xls = ds_list_create();
var xside = getSideX(dir);
collision_rectangle_list(xside, bbox_top, xside + (dir == 1 ? room_width-x : -x), bbox_bottom, wall, false, true, xls, true);

var yls = ds_list_create();
var y_dir = sign(vsp);
var yside = getSideY(y_dir);
collision_rectangle_list(bbox_left, yside, bbox_right, yside + (y_dir == 1 ? room_height-y : -y), wall, false, true, yls, true);

var wall_x = xls[| 0];
var wall_y = yls[| 0];

// Horzontal collision
if (wall_x != undefined) {
	var dis = point_distance(xside, y, getSideX(-dir, wall_x), y);
	
	if (dis < hsp) {
		x += dis * dir;
		hsp = 0;
	}
}

// Vertical collision
if (wall_y != undefined) {
	var dis = point_distance(x, yside, x, getSideY(-y_dir, wall_y));
	
	if (dis < vsp) {
		y += dis * y_dir;
		vsp = 0;
	}
}
*/

var coll = collide(hsp, vsp, wall);
hsp = coll.hsp;
vsp = coll.vsp;

#endregion

#region Apply final speed

x += hsp;
y += vsp;	

#endregion

#region Get out of walls

getOutOfWalls(wall);

#endregion

#region Cooldowns

out_of_control = max(out_of_control-1, 0);

// Assist mode
buffer_counter--;
coyote_counter--;

was_grounded = state[stat.ground];

// Top wall to normall wj change time
change_time--;

#endregion

#endregion

#region Animation
/*
sprite_index = global.animal[global.player_animal_num[player]];

// Walk and Stand
if (state[stat.ground]) {
	// Stand
	if move == 0 {
		image_speed = 0;
		image_index = 0;
	} else {
		// Move
		image_speed = 1;
	}
} else {
	// Jump
	image_speed = 0;
	
	if (move == 0){
		image_index = 0;
	} else {
		image_index = image_number-1;
	}
} 

// Set Direction
if (move != 0) dir = move;

*/
image_xscale = abs(image_xscale) * dir;

#endregion

#region Hp

// Pop up damage
var dmg =  hp_prev-hp;
dmg = floor(dmg);

if (dmg > 1) {
	showDamage(-abs(dmg), bbox_right+4, bbox_top-8, c_red, sec(0.8));
}

hp_prev = hp;

// Death
if (hp <= 0) {
	global.player_dead[player] = true;
	
	effect_create_above(1, x, y, 0, c_orange);
		
	if (global.settings.graphics_blood) {
		//repeat (150) instance_create_layer(x,y,"bullet",oBlood);
	}
	
	weapon_disable = true;
		
	instance_change(oGrave, true);
	image_index = other.player;
			
	exit;
}


// Change color when damaged or poisoned
if (dmg > 0.9) show_damage = sec(0.15); 

if (!global.show_vars) {
	if (show_damage > 0) image_blend = c_red;
	else if (poison_damage > 0) image_blend = c_lime;
	else image_blend = c_white;
}


show_damage--;

// Poison
if (poison_damage > 0) {
	poison_damage = approach(poison_damage,0,poison_dmg_per_frame);
	hp -= poison_dmg_per_frame;
	
	// Particle
	part_type_direction(global.pa_type_poison, 90, 90, 0, 25);
	
	part_emitter_region(global.pa_system_poison, global.pa_emitter_poison, x-12, x+12, bbox_top-6, bbox_top+8,
	ps_shape_rectangle, ps_distr_invgaussian);
	
	part_emitter_burst(global.pa_system_poison, global.pa_emitter_poison, global.pa_type_poison, -10);
}

#endregion

#region Other Stuff

//wrap
move_wrap(true, true, 15);

dir_prev = dir;

#endregion
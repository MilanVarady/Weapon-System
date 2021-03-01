///@desc Goto player and Shoot

#region Pick up

// Check for players
var players = ds_list_create();
var len = instance_place_list(x, y, attr.player_obj, players, false);

for (var i = 0; i < len; i++) {
	var inst = players[| i];
	
	// Check if player is pressing pickup
	if (inst.weapon_input_pickup and inst != player and pickup_delay <= 0) {
		// Resetting the new players weapon
		if (inst.weapon != noone) {
			with (player.weapon) {
				pickup_delay = 5;
				ystart = y;
				player.weapon = noone;
				player = noone;
			}
		}
		
		// Reset current players weapon
		if (player != noone) {
			player.weapon = noone;
		}
		
		// Set player and player's weapon
		player = inst;
		player.weapon = id;
		
		// Play pickup sound
		if (attr.sound.pickup == undefined) audio_play_sound(attr.pickup, 5, false);
	}
}

ds_list_destroy(players);

pickup_delay--;

#endregion

#region Goto player and shoot

if (player != noone and instance_exists(player)) {
	
	#region Goto player and set direction
	
	// Get players direction (horizontal)
	var dir = sign(player.image_xscale);
	
	// Set pos
	y = player.y + attr.pos.y_plus;
	
	image_xscale = abs(image_xscale) * dir;
	x = player.x + attr.pos.x_plus * dir;
	
	// Set shooting angle
	if (dir == 1) direction = 0;
	else direction = 180;
	
	#endregion
	
	#region Shoot
	
	// Burst
	if (shoot_counter <= 0 and burst_bullets == 0 and attr.burst_delay > 0) burst_bullets = attr.bullets_per_shot;
	
	if (attr.shooting_enabled and ((player.weapon_input_shoot) or (burst_bullets > 0 and burst_bullets < attr.bullets_per_shot)) 
		and (shoot_counter <= 0 or (burst_counter <= 0 and burst_bullets > 0)) and object_exists(attr.bullet.obj)) {	
		
		// Audio
		if (!attr.sound.is_looping and attr.sound.shoot != undefined) {
			shoot_sound = audio_play_sound(attr.sound.shoot, 10, false);
			audio_sound_pitch(shoot_sound, random_range(attr.sound.pitch_range[0], attr.sound.pitch_range[1]));
		}
		
		// Burst
		var bullet_num = attr.bullets_per_shot;
		
		if (attr.burst_delay > 0) bullet_num = 1;
		
		// Shoot x and y
		var shoot_x = bbox_right;
		var shoot_y = y;
		
		// Muzzle flash
		if (attr.muzzle_flash) {
			part_type_orientation(global.pa_type_flash, direction, direction, 0, 0, false);		
			part_particles_create(global.pa_system_flash, shoot_x, shoot_y, global.pa_type_flash, 1);
		}
		
		// Create bullet
		if (!position_meeting(shoot_x, shoot_y, oWall) or attr.bullet.go_through_walls) {
			repeat (bullet_num) {
				with instance_create_layer(shoot_x, shoot_y, layer, attr.bullet.obj) {
					// Get attr struct
					attr = snap_deep_copy(other.attr.bullet);
					
					// Give players id
					player = other.player;
					
					// Trail
					trail = undefined;
					if (attr.trail.enabled) trail = new Trail(snap_deep_copy(attr.trail));
					
					// Sprite
					sprite_index = attr.spr;
				
					// Set direction and apply bullet spread
					direction = other.direction + random_range(-other.attr.spread, other.attr.spread);
				}
			}
		}
		
		// Kickback
		kickback = attr.kickback;
		
		shoot_counter = attr.fire_rate;
		
		// Burst
		if (burst_bullets > 0) {
			burst_bullets--;
			burst_counter = attr.burst_delay;
		}
	}	
	
	
	#endregion
	
	#region Looping shot sound
	
	if (attr.sound.is_looping and attr.shooting_enabled) {
		if (player.weapon_input_shoot) {
			// Start sound
			if (looping_sound == undefined) {
				looping_sound = audio_play_sound(sound, 5, true);
			} else {
				if (audio_is_paused(looping_sound)) audio_resume_sound(looping_sound);	
			}
		} else {
			if (looping_sound != undefined and audio_is_playing(looping_sound)) audio_pause_sound(looping_sound);		
		}
	}
	
	#endregion

} else {
	// Float if not picked up
	if (attr.float) y = ystart + sin(get_timer() / 500000) * 3;	
	
	if (looping_sound != undefined and audio_is_playing(looping_sound)) audio_stop_sound(looping_sound);
}

shoot_counter--;
burst_counter--;

#endregion

#region Recoil

// Kickback

kickback = approach(kickback, 0, 1);

x = x - lengthdir_x(kickback, direction);
y = y - lengthdir_y(kickback, direction);

#endregion



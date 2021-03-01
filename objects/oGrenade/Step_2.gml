pickupMarker();

#region If not activated

pickup_delay--;

if (owner != noone) {
	if (owner.weapon_disable) exit;
	
	if (owner.in.shoot.down and !owner.weapon_disable) {
		// Set speed
		hsp = 10 * owner.dir;
		vsp = -8;
		
		audio_play_sound(snHammerWoosh,0,0);
		
		owner.weapon = noone;
		owner = noone;
		active = true;
	}
	
	if  active == false {
		y = owner.y + y_plus;
		x = owner.x + x_plus * owner.dir;
	}
} else if (!active) {
	// if not picked up float
	y = ystart + sin(get_timer()/500000)*3;	
}

#endregion

#region If activated

if active {
	// Slow down in water
	var in_water = place_meeting(x, y, oWater);
	
	var grav_final = grav;
	if (in_water) {
		grav_final *= 0.4;
		
		if (!in_water_prev) {
			hsp *= 0.5;
			vsp *= 0.5;
		}
	}
	
	in_water_prev = in_water;
	
	applyPhysics(grav_final, oWall, true, true, true, bouncedecay, 8);

	if ((place_meeting(x+hsp, y, oWall) or place_meeting(x, y+vsp, oWall)) and (!place_meeting(x, y+1, oWall))) {
		audio_sound_pitch(impact_sound, random_range(0.8, 1.2));
		audio_play_sound(impact_sound, 5, false);
	}

	// Destroy on shield
	var inst = instance_place(x,y,oShield);
	
	if (inst != noone and inst.owner != noone and inst.owner != my_player) {
		inst.hp -= 20;
		effect_create_above(ef_ring,x,y,0,c_aqua);
		instance_destroy();
	}

	move_wrap(true, true, 10);
		
		
	// Detonate
	if (until_detonate <= 0) {
		createExplosion(x,y,ex_size,ex_damage,oPlayer,layer_get_depth("weapons")-50);
		active = false;
		instance_destroy();
	}
	
	until_detonate--;
}

#endregion
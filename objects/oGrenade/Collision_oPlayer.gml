//collide with any player

if ((other.in.pickup.pressed) and other != owner and active == false and pickup_delay <= 0) {
	if (other.weapon != noone) {
		other.weapon.ystart = other.weapon.y;
		other.weapon.pickup_delay = sec(0.1);
		other.weapon.owner = noone;
	}
	
	owner = other;
	other.weapon = self;
	my_player = owner;
	audio_play_sound(pickup_sound,0,false);
}

if active and other != my_player {
	until_detonate = 0;
}
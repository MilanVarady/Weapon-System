///@desc Initialize

// Attributes struct
attr = {
	fire_rate:	6,
	spread: 	3,
	recoil: 	0,
	kickback:	4,
	
	bullets_per_shot:	3,
	burst_delay:		180,
	
	player_obj:			oPlayer,
	muzzle_flash:		false,
	float:				true,
	shooting_enabled:	true,
	
	pos: {
		x_plus: 0,
		y_plus: 0
	},
	
	bullet: {
		damage: 		10,
		speed:			10,
		spr:			sBullet,
		obj:			pBullet,
		enemy:			oEnemy,
		lifespan:		180,
		dynamic_angle:	true,
		trail:			true,
		trail_color:	c_white,
		go_through_walls: false,
		
		trail: {
			enabled:	true,
			
			length: 	6,

			width:		2,
			width_mult:	1,

			alpha:		1,
			alpha_mult:	0.9,
			
			color:		c_white
		},
		
		run_code: {
			create: 	undefined,
			step:		undefined,
			cleanup:	undefined,
			enemy:		undefined
		}
	},
	
	sound: {
		shoot:			snAk,
		pitch_range:	[0.8, 1.2],
		is_looping: 	false,
		
		pickup: 		snPickup
	}
}

// Other vars

player = noone;

burst_counter = 5;
burst_bullets = 0;

shoot_counter = 0;
kickback = 0;
pickup_delay = 0;
marker_id = noone;

looping_sound = undefined;
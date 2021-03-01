// Init variables

#macro TILE_SIZE 16
global.show_vars = false;

in_sys = new InputSystem({
	right:	["D",		gp_padr,		gp_axislr],

	left:	["A",		gp_padl,		gp_axisll],
	
	jump:	["W",		gp_face1,		gp_face4],
	
	shoot:	[vk_space,	gp_shoulderrb,	gp_face3],
	
	pickup: ["E",		gp_shoulderlb,	gp_face2]
});

#region Movement


#region Physics settings


#region Enums

enum stat {
	ground,
	air,
	wall_slide,
	top,
	water,
	len
}

enum e_wj {
	normal,
	top
}

#endregion

#region Modifier arrays

var num = stat.len;

for (var i = 0; i < num; i++) {
	m_grav[i]			= 1;
	m_move_spd_max[i]	= 1;
	m_jump_spd[i]		= 1;
	m_vsp_max[i]		= 1;
	m_vsp_min[i]		= 1;
}

#endregion

#region Boosted things

movespd_normal = 2.4;
movespd_boosted = 3.8;

jumpspd_normal = 5.2;
jumpspd_boosted = 6.2;

#endregion

for (var i = 0; i < 2; i++) {

#region Basic

grav[i]				= 0.2;				// Gravity
move_spd_max[i]		= movespd_normal;	// Move speed
vsp_max[i]			= 6;				// Max falling speed
vsp_min[i]			= 20;				// Max acension speed
hsp_dec[i]			= 0.2;				// Hsp decelartion
wall				= oWall;			// Wall obj_name

#endregion

#region Acceleration

acc[i]				= 0.4;		// Acceleration
dec[i]				= 0.8;		// Deceleration
keep_momentum		= true;		// Keep momentum when changing direction (bool)

#endregion

#region Jump/Wall Jump

var e = stat.wall_slide;

jump_spd[i]			= jumpspd_normal;	// Jump speed
jumps_max[i]		= 1;				// Jumps you have

walljump_enabled	= true;		// Wether walljump is on or off

// Wall slide
m_grav[e]			= 0.3;		// Sliding speed
m_vsp_max[e]		= 0.5;		// Max sliding speed

wj_hsp[e_wj.normal]	= 3;		// Horizontal speed when jumping off from wall
wj_vsp[e_wj.normal]	= -5;		// Vertical speed when jumping off from wall

walljump_delay_max	= 15;		// During this amount of time the player won't have control after walljumping

// Topwall
topwall_enabled		= true;					// If this is turned on if the player jumps from a top wall it will jump more vertically than horizontally
top_check_h			= TILE_SIZE*3;			// The height ti check for an empty place above the player
wj_hsp[e_wj.top]	= -1;					// Top wall horizontal speed
wj_vsp[e_wj.top]	= -4.2;					// Top wall vertical speed
change_time_max		= 8;					// inRange this time you can change the topwall jump to a normal one

#endregion

#region In water

var e = stat.water

m_grav[e]			= 0.3;
m_vsp_max[e]		= 0.4;
m_move_spd_max[e]	= 0.8;
m_jump_spd[e]		= 0.3;
m_vsp_min[e]		= 0.4;

#endregion

}

#endregion

#region Assist mode

// Jump/Input buffering
buffer_max = 8;	// Max time in frames

// Coyote time (edge tolerance)
coyote_max = 8;	// Max time in frames

#endregion

#region Needed stuff

state			= -1;
hsp				= 0;
vsp				= 0;
public_hsp		= 0;		// The hsp that others can change as well
jumps			= 0;
move			= 0;
move_spd		= 0;
was_grounded	= false;
dir				= 1;
dir_prev		= 0;
out_of_control	= 0;
change_time		= 0;		// Top walljump change time
change_dir		= 1;		// Top walljump direction
buffer_counter	= 0;		// Input buffer
coyote_counter	= 0;		// Coyote time
jumped			= false;	

#endregion


#endregion

#region Other

player = 0;

hp = 100;
shield = 0;

hp_prev = hp;

dmg_line_hp = hp;
dmg_line_shield = shield;

//damage_line = hp;
show_damage = 0;

weapon = noone;
weapon_input_pickup = false;
weapon_input_shoot = false;

weapon_disable = false;

poison_damage = 0;
poison_dmg_per_frame = 0.11;

#endregion


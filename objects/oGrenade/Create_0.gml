#region Trail

event_inherited();

trail_length = 16;

trail_width = 4;
trail_width_multiplier = 0.98;

trail_alpha_multiplier = 0.95;

trail_tp_fix = true;
trail_tp_fix_dis = 15;

#endregion

#region Grenade

hsp = 0;
vsp = 0;
grav = 0.6;
bouncedecay = 0.2;
rot_angle = 0;

image_xscale = 1;
image_yscale = image_xscale;

image_blend = c_white;

until_detonate = sec(3);

active = false;

owner = noone;

pickup_delay = 0;

pickup_sound = snPickup;
impact_sound = snGrenadeImpact;

ex_size = 3;
ex_damage = 100;

x_plus = 6;
y_plus = 8;

marker_id = noone;

in_water_prev = false;

image_speed = 0;

image_index = 0;

#endregion
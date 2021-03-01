/// @func collide(hsp, vsp, obj, [reduce_amount])

/// @desc Reduces hsp and vsp until the object won't go into the wall object

/// @param {real}			hsp				Horizontal speed
/// @param {real}			vsp				Vertical speed
/// @param {object_name}	wall_obj		Wall object
/// @param {real}			[reduce_amount]	(optional) The amount of speed reduce (default: 1)

/// @returns {struct} Struct with an hsp and vsp value

function collide(hsp, vsp, obj, rdc_amount) {
    if (rdc_amount == undefined) rdc_amount = 1;
    
    while (place_meeting(x + hsp, y, obj)) {
    	hsp = approach(hsp, 0, rdc_amount);
    }
    
    while (place_meeting(x, y + vsp, obj)) {
    	vsp = approach(vsp, 0, rdc_amount);
    }
	
	static speedVector = function(hsp, vsp) constructor {
		self.hsp = hsp;
		self.vsp = vsp;
	}
    
    return new speedVector(hsp, vsp);
}
/// @func gpCheck(gp, [pressed], [gp_num])

/// @desc Checks if a gamepad button is pressed or not

/// @param {gp}   gp			The gamepad button to check for
/// @param {bool} [pressed] 	Whether to check as pressed or not (default: false)
/// @param {real} [device]		Gamepad device number (default: 0)

/// @return {bool}

/// @example gpCheck(gp_axislr, true, global.gamepads_connected[0]);

function gpCheck(gp, pressed, gp_num) {
    if (pressed == undefined) pressed = false;
    if (gp_num == undefined) gp_num = 0;
    
	var input = false;

	if (inRange(gp_num, 0, 11)) {
		if (is_string(gp)) {
			// Gamepad axis
		
			// Check axis last val
			var key = "gp num:" + string(gp_num) + " axis_id:"+ string(gp);
			var axis_last_val = global.axis_last_val[? key];
		
			// Convert string to axis id and axis dir
			var axis_ind = real(string_digits(gp));
			var str_last = string_char_at(gp, string_length(gp));
		
			var axis_target_val = 1;
			if (str_last == "-") axis_target_val = -1;
		
			// Get value
			var axis_val = sign(gamepad_axis_value(gp_num, axis_ind));
		
			// Check input
			if (axis_val == axis_target_val) input = true;
		
			// Pressed
			if (pressed and axis_val == axis_last_val) input = false;
		
			// Add axis value to the list
			var ls = global.axis_val_ls;
			var arr = [key, axis_val];
		
			if (ds_list_find_index(ls, arr) == -1) ds_list_add(ls, arr);
		} else {
			// Gamepad button
		
			// Normal
			var input = gamepad_button_check(gp_num, gp);
		
			// Pressed
			if (pressed) {
				input = gamepad_button_check_pressed(gp_num, gp);
			}
		}
	}

	return input;
}
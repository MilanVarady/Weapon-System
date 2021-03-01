/// @func inputCheck(input/arr, [pressed], [gamepad_device])

/// @desc Checks one or more inputs of any type, returns true if any of them are pressed.

/// @param {input or array}		input/arr				One input or an array of inputs of any type
/// @param {bool}				[pressed]				Whether the input should be checked as pressed or not (default: false)
/// @param {real}				[gamepad_device]		Damepad device to check (default: 0)

/// @return {bool}

/// @example inputCheck([vk_right, "d", gp_axislr, gp_padr], true, global.gamepads_connected[0]); 

function inputCheck(inp, pressed, gp_num) {
	if (pressed == undefined) pressed = false;
	if (gp_num == undefined) gp_num = 0;
	
	var arr = is_array(inp) ? inp : [inp];
	
	var input = false;
	
	var len = getlen(arr);
	
	for (var i = 0; i < len; i++) {
		var in = arr[i];
		
		if (in == 0 or in == undefined) continue;
		
		var type = getInputType(in);
		
		switch (type) {
			case e_input_type.keyboard:
				input = keyCheck(in, pressed);
				break;
				
			case e_input_type.gamepad:
				input = gpCheck(in, pressed, gp_num);
				break;
				
			case e_input_type.mouse:
				input = mbCheck(in, pressed);
				break;
		}
		
		if (input) break;
	}
	
	return input;
}
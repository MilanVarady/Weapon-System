#macro gp_none 0

/// @func gamepadLast(device, [pressed])

/// @desc Gets last gamepad button that was pressed, similar to keyboard_key

/// @param {real} device	Gamepad device to check
/// @param {bool} [pressed]	Whether the input should be checked as pressed or not (default: false)

/// @return {input}

/// @example gamepadLast(0, false);

function gamepadLast(device, prs) {
	if (prs == undefined) prs = false;
	
	if (device != undefined) {
		if (gamepad_is_connected(device)) {
			// Check for input
			var arr = global.gamepad_inputs;
			var num = array_length(arr);
	
			for (var i = 0; i < num; i++) {
				var gp = arr[i];
		
				if (gpCheck(gp, prs, device)) {
					return gp;
					break;
				}
			}
		}
	}
	
	return gp_none;
}
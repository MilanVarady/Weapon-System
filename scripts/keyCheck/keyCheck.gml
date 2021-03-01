/// @func keyCheck(key, [pressed])

/// @desc Checks if a key is pressed or not

/// @param {vk or string}   key         The key to be checked. ord() is not accepted only vk and string (e.g. vk_left, "a", "1")
/// @param {bool}          [pressed]	Whether to check as pressed or not (default: false)

/// @return {bool}

/// @example keyCheck(vk_right, true);

function keyCheck(key, pressed) {
    if (pressed == undefined) pressed = false;
    
	var input = false;
	
	if (is_string(key)) {
		if (string_length(key) == 1) key = ord(string_upper(key));
	}

	if (pressed) input = keyboard_check_pressed(key);
	else input = keyboard_check(key);

	return input;
}
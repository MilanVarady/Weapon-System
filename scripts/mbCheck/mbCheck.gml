/// @func mbCheck(mouse_button, [pressed])

/// @desc Checks if a mouse button is pressed or not

/// @param {mb}     mouse_button    Mouse button to check for
/// @param {bool}	[pressed]       Whether to check as pressed or not (default: false)

/// @return {bool}

/// @example mbCheck(mb_left, true);

function mbCheck(mb, pressed) {
    if (pressed == undefined) pressed = false;
    
	var input = false;

	if (pressed) input = mouse_check_button_pressed(mb);
	else input = mouse_check_button(mb);

	return input;
}
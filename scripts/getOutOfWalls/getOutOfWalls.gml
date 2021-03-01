/// @func getOutOfWalls(wall_obj)

/// @desc Finds the closest way out of an object and jumps to that position

/// @param {object_name} wall_obj	The object to get out of

/// @returns {undefined}			N/A

function getOutOfWalls(wall) {
	if (place_meeting(x,y,wall)) {
		for (var i = 0; i < 1000; i++) {
			// Right
			if (!place_meeting(x + i, y, wall)) {
				x += i;
				break;
			}
		
			// Left
			if (!place_meeting(x - i, y, wall)) {
				x -= i;
				break;
			}
		
			// Up
			if (!place_meeting(x, y - i, wall)) {
				y -= i;
				break;
			}
		
			// Down
			if (!place_meeting(x, y + i, wall)) {
				y += i;
				break;
			}
		
			// Top right
			if (!place_meeting(x + i, y - i, wall)) {
				x += i;
				y -= i;
				break;
			}
		
			// Top left
			if (!place_meeting(x - i, y - i, wall)) {
				x -= i;
				y -= i;
				break;
			}
		
			// Bottom right 
			if (!place_meeting(x + i, y + i, wall)) {
				x += i;
				y += i;
				break;
			}
		
			// Bottom left
			if (!place_meeting(x - i, y + i, wall)) {
				x -= i;
				y += i;
				break;
			}
		}
	}
}

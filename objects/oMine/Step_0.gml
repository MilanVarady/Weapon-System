///@desc Physics

if (place_meeting(x, y+1, oWall)) onground = true;
else onground = false;

applyPhysics(0.4, oWall, false, true, false, 0, 8);

move_wrap(false, true, sprite_height/2);
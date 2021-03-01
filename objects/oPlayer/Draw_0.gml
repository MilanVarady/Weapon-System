

draw_self();

var bar_width = 20;
var bar_height = 3;
var bar_y = bbox_top - 10;

var x1 = x-bar_width/2;
var x2 = x+bar_width/2;
var y1 = bar_y;
var y2 = bar_y - bar_height;


// Health bar
dmg_line_hp = drawHealthbarAdvanced(x1, y1, x2, y2, hp, 100, dmg_line_hp, c_black, c_red, c_lime, 0, true, c_red);

// Shield bar
if (shield > 0) {
	var shield_bar_y_offset = -2;
	
	y1 = y2+shield_bar_y_offset;
	var y2 = y1 - bar_height;
	
	dmg_line_shield = drawHealthbarAdvanced(x1, y1, x2, y2, shield, 50, dmg_line_shield, c_black, c_blue, c_aqua, 0, true, c_orange);
}

// Pisoned icon
if (poison_damage > 0) {
	draw_sprite(sPoisonSkullSmall, 0, x+18, bbox_top-12);
}

if (!global.show_vars) exit;

draw_circle(x + ((abs(sprite_width/2) + (TILE_SIZE/4)) * dir), bbox_top - TILE_SIZE, 2, false);

draw_set_font(fPixel);

draw_set_color(c_red);

draw_text(x+20, bbox_top-24,	"hsp: "			+ string(hsp));
draw_text(x+20, bbox_top-16,	"move_spd: "	+ string(move_spd));
draw_text(x+20, bbox_top-8,		"buffer: "		+ string(buffer_counter));
draw_text(x+20, bbox_top-0,		"coyte: "		+ string(coyote_counter));
draw_text(x+20, bbox_top+8,		"jumps: "		+ string(jumps));
draw_text(x+20, bbox_top+16,	"ch time: "		+ string(change_time));
draw_text(x+20, bbox_top+24,	"shoot: "		+ string(in.shoot));

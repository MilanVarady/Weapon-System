function drawHealthbarAdvanced(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12) {
	// Must be used like this:
	// dmg_line = drawHealthbarAdvanced(...);

	///@param x1
	///@param y1
	///@param x2
	///@param y2
	///@param Hp
	///@param MaxHp
	///@param BackCol
	///@param MinCol
	///@param MaxCol
	///@param Dir
	///@param ShowBack
	///@param ShowBorder
	///@param DmglineCol

	var x1 = argument0;
	var y1 = argument1;
	var x2 = argument2;
	var y2 = argument3;
	var hp = argument4;
	var max_hp = argument5;
	var dmg_line = argument6
	var back_col = argument7;
	var min_col = argument8;
	var max_col = argument9;
	var dir = argument10;
	var show_back = argument11;
	var dmg_line_col = argument12;


	// Draw damage line
	if (hp > dmg_line) dmg_line = hp;
	else dmg_line -= 0.5;

	var amount = (dmg_line / max_hp) * 100;

	draw_healthbar(x1, y1, x2, y2, amount, back_col, dmg_line_col, dmg_line_col, dir, show_back, false);

	// Draw healthbar
	var hp = (hp / max_hp) * 100;

	draw_healthbar(x1, y1, x2, y2, hp, back_col, min_col, max_col, dir, false, false);

	return dmg_line;


}

/// @desc Collisions and trail points

// Trail
if (trail != undefined) trail.update(x, y);

if (attr.dynamic_angle) image_angle = direction;

var x_len = lengthdir_x(attr.speed, direction);
var y_len = lengthdir_y(attr.speed, direction);

#region Collisions

var exit_for = false;

var list = ds_list_create();

var num = collision_line_list(x, y, x + x_len, y + y_len, all, false, false, list, true);

for (var i = 0; i < num; i++) {
	var inst = list[| i];
			
	if (inst != noone) {
		switch inst.object_index {
			case attr.enemy:
				if (inst != player) {
					if (variable_instance_exists(inst, "hp")) inst.hp -= attr.damage;
					
					instance_destroy();
					exit_for = true;
				}	
				break;
						
			case oWall:
				if (!attr.go_through_walls) instance_destroy();
				exit_for = true;
				break;
		}
		
		if (exit_for) break;
	}
}

ds_list_destroy(list);
	
#endregion

x += x_len;
y += y_len;

// Other stuff
if (attr.lifespan <= 0) instance_destroy();

attr.lifespan--;
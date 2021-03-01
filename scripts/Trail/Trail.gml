function Trail(attr) constructor {
    list_points = ds_list_create();
    
    self.attr = attr
    
    /*
    attr = {
        length:     8,
        
        width:      2,
        width_mult: 1,
        
        alpha:      1,
        alpha_mult: 1,
    
        color:      c_white,
    }
    */
    
    // Teleport fix
    // If the object travels too much in one frame (eg. teleport, room wrap) the trail will be cleared
    tp_fix      = false;    // Whether theleport fix is on or off
    tp_fix_dis  = 0;	    // The distance to clear at (e.g. move_speed + some_amount)
    
    static update = function(x, y) {
        if (!ds_exists(list_points, ds_type_list)) exit;

        #region Delete points
        
        var list = list_points;
        var len = ds_list_size(list);
        
        if (len >= attr.length) {
        	var grid_point = list_points[| 0];
        	
        	if (ds_exists(grid_point, ds_type_grid)) {
        		ds_grid_destroy(grid_point);	
        	}
        	
        	ds_list_delete(list_points, 0);
        }
        
        #endregion
        
        #region Teleport fix
        
        var len = ds_list_size(list);
        
        if (tp_fix and len > 0) {
        	var grid_point = list[| len-1];
        	var x_prev = grid_point[# 0, e_point.x]
        	var y_prev = grid_point[# 0, e_point.y]
        
        	if (point_distance(x, y, x_prev, y_prev) > tp_fix_dis) {
        		for (var i = 0; i < len; i++) {
        			var grid_point = list_points[| i];
        	
        			if (ds_exists(grid_point, ds_type_grid)) {
        				ds_grid_destroy(grid_point);	
        			}
        		}
        
        		ds_list_clear(list_points);
        	}
        }
        
        #endregion
        
        #region Ad points
        
        var grid_point = ds_grid_create(1, e_point.length);
        
        grid_point[# 0, e_point.x] = x;
        grid_point[# 0, e_point.y] = y;
        grid_point[# 0, e_point.width] = attr.width;
        grid_point[# 0, e_point.alpha] = attr.alpha;
        
        ds_list_add(list_points, grid_point);
        
        #endregion
        
        #region Refresh width and alpha
        
        var list = list_points;
        var len = ds_list_size(list);
        
        for (var i = 0; i < len; i++) {
        	var grid_point = list[| i];
        	
        	grid_point[# 0, e_point.width] *= attr.width_mult;
        	grid_point[# 0, e_point.alpha] *= attr.alpha_mult;
        }
        
        #endregion
    }
    
    static draw = function() {
        if (!ds_exists(list_points, ds_type_list)) exit;

        #region Draw the primitive
        
        draw_set_color(attr.color);
        
        draw_primitive_begin(pr_trianglestrip);
        
        var list = list_points;
        var len = ds_list_size(list);
        
        for (var i = 0; i < len - 1; i++) {
        	var grid_point1 = list[| i];
        	var grid_point2 = list[| i+1];
        	
        	draw_set_alpha(grid_point1[# 0, e_point.alpha]);
        	 
        	var x1 = grid_point1[# 0, e_point.x];
        	var y1 = grid_point1[# 0, e_point.y];
        	var w1 = grid_point1[# 0, e_point.width]/2;
        	 
        	var x2 = grid_point2[# 0, e_point.x];
        	var y2 = grid_point2[# 0, e_point.y];
        	var w2 = grid_point2[# 0, e_point.width]/2;
        	 
        	var dir = point_direction(x1, y1, x2, y2);
        	 
        	var ortho_dir1 = dir + 90;
        	var ortho_dir2 = dir - 90;
        	 
        	draw_vertex(x1 + lengthdir_x(w1, ortho_dir1), y1 + lengthdir_y(w1, ortho_dir1));
        	draw_vertex(x1 + lengthdir_x(w1, ortho_dir2), y1 + lengthdir_y(w1, ortho_dir2));
        	 
        	draw_vertex(x2 + lengthdir_x(w2, ortho_dir1), y2 + lengthdir_y(w2, ortho_dir1));
        	draw_vertex(x2 + lengthdir_x(w2, ortho_dir2), y2 + lengthdir_y(w2, ortho_dir2));
        }
        
        draw_primitive_end();
        
        draw_set_alpha(1);
        
        #endregion
    }
    
    static cleanup = function() {
        if (!ds_exists(list_points, ds_type_list)) exit;
        
        var num = ds_list_size(list_points);
        
        for (var i = 0; i < num; i++) {
        	var grid_point = list_points[| i];
        	
        	if (ds_exists(grid_point, ds_type_grid)) {
        		ds_grid_destroy(grid_point);	
        	}
        }
        
        ds_list_destroy(list_points);
    }
}

enum e_point {
	x,
	y,
	width,
	alpha,
	length
}
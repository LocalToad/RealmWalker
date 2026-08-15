extends Node2D

const fog_map = preload("res://Scenes/fog_map.tscn")
var current_fog: Node2D = null

func _look(looker_pos):
	
	if current_fog == null:
		current_fog = lib._spawn(fog_map, Vector2(0,0))
	
	if current_fog.has_node("TileMapLayer"):
		var fog_tile_layer: TileMapLayer = current_fog.get_node("TileMapLayer")
	
	var space_state = get_world_2d().direct_space_state
	
	for x in range(-20, 21):
		for y in range(-20, 21):
			if current_fog.has_node("TileMapLayer"):
				var fog_tile_layer: TileMapLayer = current_fog.get_node("TileMapLayer")
				if fog_tile_layer.get_cell_source_id(Vector2i(x, y)) ==0:
					var x_dir = 1 if x < looker_pos.x else -1
					var y_dir = 1 if y < looker_pos.y else -1
					var test_point = lib._tile_to_pixel_center(x, y) + Vector2(x_dir, y_dir) * 16 / 2
					
					var query = PhysicsRayQueryParameters2D.create(looker_pos, test_point)
					var occlusion = space_state.intersect_ray(query)
					if !occlusion || (occlusion.position - test_point).length() < 2:
						fog_tile_layer.erase_cell(Vector2i(x, y))
						
						
						

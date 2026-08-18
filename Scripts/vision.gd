extends Node2D

const fog_map = preload("res://Scenes/fog_map.tscn")
var current_fog_node: Node2D = null
var _fog_tile_layer: TileMapLayer
var x_dir = 1
var y_dir = 1
var temp_pos: Vector2
var map_node = Node2D
var tile_collision_polygons
var query
var query_1
var query_2
var query_3
var query_4
var occlusion
var occlusion_1
var occlusion_2
var occlusion_3
var occlusion_4
var test_tile_data: TileData
var map_tile_map_layer: TileMapLayer
var test_point 
var test_1
var test_2
var test_3
var test_4
var test_tile_data_1
var test_tile_data_2
var test_tile_data_3
var test_tile_data_4
var test_tile_data_5
var test_tile_data_6
var test_tile_data_7
var test_tile_data_8
var adjacent_fog_1
var adjacent_fog_2
var adjacent_fog_3
var adjacent_fog_4
var adjacent_fog_5
var adjacent_fog_6
var adjacent_fog_7
var adjacent_fog_8

func _look(looker_pos_pixel_center: Vector2):
	
	#map_node = lib.startingWell.get_node("TileMap")
	#print(str(map_node))
	
	if current_fog_node == null:
		current_fog_node = lib._spawn(fog_map, Vector2(0,0))
		print("successfully ser current_fog_node: " + str(current_fog_node))
		_fog_tile_layer = current_fog_node.get_node("TileMapLayer")
		
	var space_state = get_world_2d().direct_space_state
	
	for x in range(-20, 21):
		for y in range(-20, 21):
			
			query = null
			occlusion = null
			test_tile_data = null
			map_tile_map_layer = null
			test_point = null
			tile_collision_polygons = null

			if current_fog_node.has_node("TileMapLayer"):
				_fog_tile_layer = current_fog_node.get_node("TileMapLayer")
				
				if _fog_tile_layer.get_cell_source_id(Vector2i(x, y)) ==0:
					
					temp_pos = lib._pixel_center_to_tile(looker_pos_pixel_center)
					
					if(x > temp_pos.x):
						x_dir = 1
					else:
						x_dir = -1
					if(y > temp_pos.y):
						y_dir = 1
					else:
						y_dir = -1
					
					if(Vector2(x, y) == Vector2(0, 0) || Vector2(x, y) == Vector2(0, 2) || Vector2(x, y) == Vector2(2, 0) || Vector2(x, y) == Vector2(2, 2) || Vector2(x, y) == Vector2(3, 3) || Vector2(x, y) == Vector2(7, 0)):
						print("testing tile:")
						print("x = " + str(x))
						print("y = " + str(y))
						print("x_dir = " + str(x_dir))
						print("y_dir = " + str(y_dir))
						if(x_dir == 1 and y_dir == 1):
							print("tile is right and down from the player")
						elif(x_dir == -1 and y_dir == 1):
							print("tile is left and down from the player")
						elif(x_dir == 1 and y_dir == -1):
							print("tile is right and up from the player")
						elif(x_dir == -1 and y_dir == -1):
							print("tile is left and up from the player")
					
					test_point = lib._tile_to_pixel_center(Vector2(x, y))
					
					map_tile_map_layer = Global.map.get_node("Walls")
					test_tile_data = map_tile_map_layer.get_cell_tile_data(Vector2(x, y))
					
					if(Vector2(x, y) == Vector2(0, 0) || Vector2(x, y) == Vector2(0, 2) || Vector2(x, y) == Vector2(2, 0) || Vector2(x, y) == Vector2(2, 2) || Vector2(x, y) == Vector2(3, 3) || Vector2(x, y) == Vector2(7, 0)):
						print("test_tile_data: " + str(test_tile_data))
						print("test_tile_data != null" + str(test_tile_data != null))
						if(test_tile_data == null):
							print("test_tile_data: " + "null")
					if(test_tile_data != null):
						tile_collision_polygons = test_tile_data.get_collision_polygons_count(0)
						print("tile_collision_polygons: " + str(tile_collision_polygons))
					
					#3 pixels from the edge
					
					if(tile_collision_polygons != null and tile_collision_polygons > 0):
						if(x_dir == 1 and y_dir == 1):
							test_point = test_point + Vector2(-8, -8)
						elif(x_dir == -1 and y_dir == 1):
							test_point = test_point + Vector2(8, -8)
						elif(x_dir == 1 and y_dir == -1):
							test_point = test_point + Vector2(-8, 8)
						elif(x_dir == -1 and y_dir == -1):
							test_point = test_point + Vector2(8, 8)
							
						query = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_point)
						occlusion = space_state.intersect_ray(query)
							
						if !occlusion || (occlusion.position - test_point).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							print("Clearing tile: " + str(Vector2i(x, y)))
							print("the pixel we drew raycast to: ")
							print("pixel: " + str(test_point))
							print("the tile pixel we drew raycast from: ")
							print("pixel: " + str(looker_pos_pixel_center))
						
					if(tile_collision_polygons == null):
						test_1 = test_point + Vector2(5 ,0)
						test_2 = test_point + Vector2(0 ,5)
						test_3 = test_point + Vector2(-5 ,0)
						test_4 = test_point + Vector2(0 ,-5)
						query_1 = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_1)
						query_2 = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_2)
						query_3 = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_3)
						query_4 = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_4)
						occlusion_1 = space_state.intersect_ray(query_1)
						occlusion_2 = space_state.intersect_ray(query_2)
						occlusion_3 = space_state.intersect_ray(query_3)
						occlusion_4 = space_state.intersect_ray(query_4)
						#print("help: " + str(test_1))
						#print("help: " + str(test_2))
						#print("help: " + str(test_3))
						#print("help: " + str(test_4))
						#print("help: " + str(query_1))
						#print("help: " + str(query_2))
						#print("help: " + str(query_3))
						#print("help: " + str(query_4))
						#print("help: " + str(occlusion_1))
						#print("help: " + str(occlusion_2))
						#print("help: " + str(occlusion_3))
						#print("help: " + str(occlusion_4))
						
						if !occlusion_1 || (occlusion_1.position - test_1).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							print("Clearing tile: " + str(Vector2i(x, y)))
							print("the pixel we drew raycast to: ")
							print("test_1: " + str(test_1))
							print("the tile pixel we drew raycast from: ")
							print("pixel: " + str(looker_pos_pixel_center))
							
						if !occlusion_2 || (occlusion_2.position - test_2).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							print("Clearing tile: " + str(Vector2i(x, y)))
							print("the pixel we drew raycast to: ")
							print("test_2: " + str(test_2))
							print("the tile pixel we drew raycast from: ")
							print("pixel: " + str(looker_pos_pixel_center))
							
						if !occlusion_3 || (occlusion_3.position - test_3).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							print("Clearing tile: " + str(Vector2i(x, y)))
							print("the pixel we drew raycast to: ")
							print("test_3: " + str(test_3))
							print("the tile pixel we drew raycast from: ")
							print("pixel: " + str(looker_pos_pixel_center))
							
						if !occlusion_4 || (occlusion_4.position - test_4).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							print("Clearing tile: " + str(Vector2i(x, y)))
							print("the pixel we drew raycast to: ")
							print("test_4: " + str(test_4))
							print("the tile pixel we drew raycast from: ")
							print("pixel: " + str(looker_pos_pixel_center))
							
					if(tile_collision_polygons == null):
						
						test_tile_data_1 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(1, 0)))
						test_tile_data_2 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(0, 1)))
						test_tile_data_3 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(-1, 0)))
						test_tile_data_4 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(0, -1)))
						
						test_tile_data_5 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(1, 1)))
						test_tile_data_6 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(1, -1)))
						test_tile_data_7 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(-1, 1)))
						test_tile_data_8 = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(-1, -1)))
						
						adjacent_fog_1 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(1, 0))
						adjacent_fog_2 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(0, 1))
						adjacent_fog_3 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(-1, 0))
						adjacent_fog_4 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(0, -1))
						
						adjacent_fog_5 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(1, 1))
						adjacent_fog_6 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(1, -1))
						adjacent_fog_7 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(-1, 1))
						adjacent_fog_8 = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(-1, -1))
						
						if(Vector2(x, y) == Vector2(7, 0)):
							if(test_tile_data_1 != null):
								print("test_tile_data_1 " + str(test_tile_data_1))
							if(test_tile_data_2 != null):
								print("test_tile_data_2 " + str(test_tile_data_2))
							if(test_tile_data_3 != null):
								print("test_tile_data_3 " + str(test_tile_data_3))
							if(test_tile_data_4 != null):
								print("test_tile_data_4 " + str(test_tile_data_4))
						
						if (test_tile_data_1 != null and test_tile_data_2 != null and adjacent_fog_5 != null):
							if(test_tile_data_1.get_collision_polygons_count(0) > 0 and test_tile_data_2.get_collision_polygons_count(0) > 0 and test_tile_data_5 == null and adjacent_fog_1 == -1 and adjacent_fog_2 == -1 and adjacent_fog_5 == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								print("Clearing tile: " + str(Vector2i(x, y)))
								print("corner exception")
						if (test_tile_data_2 != null and test_tile_data_3 != null and adjacent_fog_7 != null):
							if(test_tile_data_2.get_collision_polygons_count(0) > 0 and test_tile_data_3.get_collision_polygons_count(0) > 0 and test_tile_data_7 == null and adjacent_fog_2 == -1 and adjacent_fog_3 == -1 and adjacent_fog_7 == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								print("Clearing tile: " + str(Vector2i(x, y)))
								print("corner exception")
						if (test_tile_data_3 != null and test_tile_data_4 != null and adjacent_fog_8 != null):
							if(test_tile_data_3.get_collision_polygons_count(0) > 0 and test_tile_data_4.get_collision_polygons_count(0) > 0 and test_tile_data_8 == null and adjacent_fog_3 == -1 and adjacent_fog_4 == -1 and adjacent_fog_8 == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								print("Clearing tile: " + str(Vector2i(x, y)))
								print("corner exception")
						if (test_tile_data_4 != null and test_tile_data_1 != null and adjacent_fog_6 != null):
							if(test_tile_data_4.get_collision_polygons_count(0) > 0 and test_tile_data_1.get_collision_polygons_count(0) > 0 and test_tile_data_6 == null and adjacent_fog_4 == -1 and adjacent_fog_1 == -1 and adjacent_fog_6 == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								print("Clearing tile: " + str(Vector2i(x, y)))
								print("corner exception")

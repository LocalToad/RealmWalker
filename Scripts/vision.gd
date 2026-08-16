extends Node2D

const fog_map = preload("res://Scenes/fog_map.tscn")
var current_fog_node: Node2D = null
var _fog_tile_layer: TileMapLayer
var x_dir = 1
var y_dir = 1
var temp_pos: Vector2
var map_node = Node2D

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
					
					if(Vector2(x, y) == Vector2(0, 0) || Vector2(x, y) == Vector2(0, 2) || Vector2(x, y) == Vector2(2, 0) || Vector2(x, y) == Vector2(2, 2)):
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
					
					var test_point = lib._tile_to_pixel_center(Vector2(x, y))
					
					if(x_dir == 1 and y_dir == 1):
						test_point = test_point + Vector2(-8, -8)
					elif(x_dir == -1 and y_dir == 1):
						test_point = test_point + Vector2(8, -8)
					elif(x_dir == 1 and y_dir == -1):
						test_point = test_point + Vector2(-8, 8)
					elif(x_dir == -1 and y_dir == -1):
						test_point = test_point + Vector2(8, 8)
						
					#if(x_dir == 1 and y_dir == 1):
						#test_point = test_point
					#elif(x_dir == -1 and y_dir == 1):
						#test_point = test_point
					#elif(x_dir == 1 and y_dir == -1):
						#test_point = test_point
					#elif(x_dir == -1 and y_dir == -1):
						#test_point = test_point
					
					var query = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_point)
					var occlusion = space_state.intersect_ray(query)
					
					
					if !occlusion || (occlusion.position - test_point).length() < 1:
						_fog_tile_layer.erase_cell(Vector2i(x, y))
						print("Clearing tile: " + str(Vector2i(x, y)))
						print("the pixel we drew raycast to: ")
						print("pixel: " + str(test_point))
						print("the tile pixel we drew raycast from: ")
						print("pixel: " + str(looker_pos_pixel_center))
						
				#if _fog_tile_layer.get_cell_source_id(Vector2i(x, y)) ==0:
					#temp_pos.x = x
					#temp_pos.y = y
					#var test_point = lib._tile_to_pixel_center(temp_pos) + Vector2(x_dir_neg, y_dir_neg) * 16 / 2
					#var query = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_point)
					#var occlusion = space_state.intersect_ray(query)
					#if !occlusion || (occlusion.position - test_point).length() < 1:
						#_fog_tile_layer.erase_cell(Vector2i(x, y))
						#
				#if _fog_tile_layer.get_cell_source_id(Vector2i(x, y)) ==0:
					#temp_pos.x = x
					#temp_pos.y = y
					#var test_point = lib._tile_to_pixel_center(temp_pos) + Vector2(x_dir_pos, y_dir_neg) * 16 / 2
					#var query = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_point)
					#var occlusion = space_state.intersect_ray(query)
					#if !occlusion || (occlusion.position - test_point).length() < 1:
						#_fog_tile_layer.erase_cell(Vector2i(x, y))
						#
				#if _fog_tile_layer.get_cell_source_id(Vector2i(x, y)) ==0:
					#temp_pos.x = x
					#temp_pos.y = y
					#var test_point = lib._tile_to_pixel_center(temp_pos) + Vector2(x_dir_neg, y_dir_pos) * 16 / 2
					#var query = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_point)
					#var occlusion = space_state.intersect_ray(query)
					#if !occlusion || (occlusion.position - test_point).length() < 1:
						#_fog_tile_layer.erase_cell(Vector2i(x, y))

extends Node2D

#This imports the fog map from the scenes folder for use in this script
const fog_map = preload("res://Scenes/fog_map.tscn")

#variable initialization
#This is a lot of initialization and will be reduced or reworked in the future, all variables explained below
var current_fog_node: Node2D = null
var _fog_tile_layer: TileMapLayer
var x_dir:int = 1
var y_dir:int = 1
var temp_pos: Vector2
var map_node: Node2D
var tile_collision_polygons: int
var query: PhysicsRayQueryParameters2D
var query_right: PhysicsRayQueryParameters2D
var query_down: PhysicsRayQueryParameters2D
var query_left: PhysicsRayQueryParameters2D
var query_up: PhysicsRayQueryParameters2D
var occlusion: Dictionary
var occlusion_right: Dictionary
var occlusion_down: Dictionary
var occlusion_left: Dictionary
var occlusion_up: Dictionary
var test_tile_data: TileData
var map_tile_map_layer: TileMapLayer
var test_point: Vector2
var test_right: Vector2
var test_down: Vector2
var test_left: Vector2
var test_up: Vector2
var test_tile_data_east: TileData
var test_tile_data_south: TileData
var test_tile_data_west: TileData
var test_tile_data_north: TileData
var test_tile_data_south_east: TileData
var test_tile_data_north_east: TileData
var test_tile_data_south_west: TileData
var test_tile_data_north_west: TileData
var adjacent_fog_east: int
var adjacent_fog_south: int
var adjacent_fog_west: int
var adjacent_fog_north: int
var adjacent_fog_south_east: int
var adjacent_fog_north_east: int
var adjacent_fog_south_west: int
var adjacent_fog_north_west: int

#The function expects a PIXEL CENTER. Be careful when caling to send that. Use the lib function to convert ahead of time if needed, could maybe convert here later with an argument
func _look(looker_pos_pixel_center: Vector2):
	
	#If we haven't already, we spawn a node that contains the fog_map scene which is a 20x20 tile black square, and we take the TileMapLayer to edit later
	if current_fog_node == null:
		current_fog_node = lib._spawn(fog_map, Vector2(0,0))
		#print("successfully set current_fog_node: " + str(current_fog_node))
		_fog_tile_layer = current_fog_node.get_node("TileMapLayer")
	
	#This kind of hooks into the physics engine idk, it's important
	var space_state = get_world_2d().direct_space_state
	
	#These for loops check every tile on the 20x20 grid, and then some, just to be safe
	for x in range(-20, 21):
		for y in range(-20, 21):
			
			#These are null initializations for the second checked tile and beyond, because otherwise the variables don't get cleared
			query = null
			occlusion = { }
			test_tile_data = null
			map_tile_map_layer = null
			#test_point = null
			tile_collision_polygons = -1
			
			#This checks if the fog node has a tile map layer. I'm not sure this is necessary
			if current_fog_node.has_node("TileMapLayer"):
				#this sets the TileMapLayer we're editing for vision, again. If we didn't spawn the fog_map scene because it already existed, we wouldn't know what TileMapLayer to use.
				#Above _fog_tile_layer assignment may be redundant
				_fog_tile_layer = current_fog_node.get_node("TileMapLayer")
				
				#We check to see if the tile hasn't already been cleared, then we continue to the main function.
				if _fog_tile_layer.get_cell_source_id(Vector2i(x, y)) ==0:
					
					#We figure out the direction the tile is from the player, this is represented as positive or negative in the x or y direction
					temp_pos = lib._pixel_center_to_tile(looker_pos_pixel_center)
					if(x > temp_pos.x):
						x_dir = 1
					else:
						x_dir = -1
					#Remember that y direction is upside-down for some god-forsaken reason
					if(y > temp_pos.y):
						y_dir = 1
					else:
						y_dir = -1
					
					#This is debug text. If we check specific tiles, print some debug text about 2 things
					#if(Vector2(x, y) == Vector2(0, 0) || Vector2(x, y) == Vector2(0, 2) || Vector2(x, y) == Vector2(2, 0) || Vector2(x, y) == Vector2(2, 2) || Vector2(x, y) == Vector2(3, 3) || Vector2(x, y) == Vector2(7, 0)):
						#1) which tile we're testing and...
						#print("testing tile:")
						#print("x = " + str(x))
						#print("y = " + str(y))
						#2) what direction it is from the player
						#print("x_dir = " + str(x_dir))
						#print("y_dir = " + str(y_dir))
						#if(x_dir == 1 and y_dir == 1):
							#print("tile is right and down from the player")
						#elif(x_dir == -1 and y_dir == 1):
							#print("tile is left and down from the player")
						#elif(x_dir == 1 and y_dir == -1):
							#print("tile is right and up from the player")
						#elif(x_dir == -1 and y_dir == -1):
							#print("tile is left and up from the player")
					
					#This gets the center pixel vertex of the tile we're checking
					test_point = lib._tile_to_pixel_center(Vector2(x, y))
					
					#This imports the Node then TileMapLayer named "Walls" of whatever the currently active map is, for collision checks
					map_tile_map_layer = Global.map.get_node("Walls")
					test_tile_data = map_tile_map_layer.get_cell_tile_data(Vector2(x, y))
					
					#More tile-specific debugging.
					#if(Vector2(x, y) == Vector2(0, 0) || Vector2(x, y) == Vector2(0, 2) || Vector2(x, y) == Vector2(2, 0) || Vector2(x, y) == Vector2(2, 2) || Vector2(x, y) == Vector2(3, 3) || Vector2(x, y) == Vector2(7, 0)):
						#This lets you know what data is in the tile you're checking
						#print("test_tile_data: " + str(test_tile_data))
						#This lets you know the result of the question "Does the tile we're checking have any data?"
						#print("test_tile_data != null: " + str(test_tile_data != null))
						#if(test_tile_data == null):
							#print("test_tile_data: " + "null")
					
					#If we have any tile data at all on the tile we're checking for line of sight, then we check how many collision polygons the tile has.
					if(test_tile_data != null):
						tile_collision_polygons = test_tile_data.get_collision_polygons_count(0)
						#Then we print how many it has for debug
						#print("tile_collision_polygons: " + str(tile_collision_polygons))
					
					if(tile_collision_polygons != null and tile_collision_polygons <= 0):
						print("tile_collision_polygons was null and had 0 or less polygons. wtf.")
					
					#So, if we have collision data and we have collision polygons, it's a wall.
					#Because of that, we use this part of the function to determine line of sight.
					#Later, we will check to see if the tile is a floor and use another method to determine line of sight.
					if(tile_collision_polygons != null and tile_collision_polygons > 0):
						#We modify the pixel vertex we're checking for line of sight.
						#It changes from the center of the tile to the edge vertex that is closest to wherever we're looking from.
						if(x_dir == 1 and y_dir == 1):
							test_point = test_point + Vector2(-8, -8)
						elif(x_dir == -1 and y_dir == 1):
							test_point = test_point + Vector2(8, -8)
						elif(x_dir == 1 and y_dir == -1):
							test_point = test_point + Vector2(-8, 8)
						elif(x_dir == -1 and y_dir == -1):
							test_point = test_point + Vector2(8, 8)
						
						#This is some physics bullshit idk, it's necessary af.
						#the query line takes two points and gets data about a ray between those points.
						#the occlusion line does come magic idk, pro extracts some data from a function in PhysicsRayQueryParameters2D
						query = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_point)
						occlusion = space_state.intersect_ray(query)
							
						#If we don't have any occlusion data, then we haven't intersected with anything, and pass the line of sight check
						#but we always or almost always hit the corner of the wall and get collision data.
						#so we also check to see if the collision point is at most one pixel away from whatever vertex we're testing
						if !occlusion || (occlusion.position - test_point).length() < 1:
							#Then we clear the fog tile and the player can see what's beneath (in this case, a wall)
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							#If we need to tell the console why we did that we print this
							#print("Clearing tile: " + str(Vector2i(x, y)))
							#print("the pixel we drew raycast to: ")
							#print("pixel: " + str(test_point))
							#print("the tile pixel we drew raycast from: ")
							#print("pixel: " + str(looker_pos_pixel_center))
						
					#If we have no data on if there's collision polygons, then this tile is a floor, or a... something... that's not a wall.
					if(tile_collision_polygons == null):
						#We split the test point into 4 test points, each is 5 pixels away from the center vertex orthogonally
						#We do this because drawing a single ray to the center of the test tile produces poor results.
						test_right = test_point + Vector2(5 ,0)
						test_down = test_point + Vector2(0 ,5)
						test_left = test_point + Vector2(-5 ,0)
						test_up = test_point + Vector2(0 ,-5)
						#These 8 lines draw rays from wherever we're looking from to those 4 test points
						query_right = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_right)
						query_down = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_down)
						query_left = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_left)
						query_up = PhysicsRayQueryParameters2D.create(looker_pos_pixel_center, test_up)
						occlusion_right = space_state.intersect_ray(query_right)
						occlusion_down = space_state.intersect_ray(query_down)
						occlusion_left = space_state.intersect_ray(query_left)
						occlusion_up = space_state.intersect_ray(query_up)
						
						#I was losing my mind and needed each of the test points and test data at some point. Gonna remove this. or not if it gets reworked
						#print("help: " + str(test_right))
						#print("help: " + str(test_down))
						#print("help: " + str(test_left))
						#print("help: " + str(test_up))
						#print("help: " + str(query_right))
						#print("help: " + str(query_down))
						#print("help: " + str(query_left))
						#print("help: " + str(query_up))
						#print("help: " + str(occlusion_right))
						#print("help: " + str(occlusion_down))
						#print("help: " + str(occlusion_left))
						#print("help: " + str(occlusion_up))
						
						#This is the same check as before for the walls.
						#If we don't have any occlusion data, then we haven't intersected with anything, and pass the line of sight check
						#We might barely hit some collision, in an edge case that doesn't exist yet
						#so we also check to see if the collision point is at most one pixel away from whatever vertex we're testing
						
						#These 4 if statements test each of the 4 split vertexes. Because checking the center of the tile produces poor results.
						if !occlusion_right || (occlusion_right.position - test_right).length() < 1:
							#Then we clear the fog tile and the player can see what's beneath (in this case, a floor, or anything else the player can see through, or something unexpected if it bugs out)
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							#If we need to tell the console why we did that we print this
							#print("Clearing tile: " + str(Vector2i(x, y)))
							#print("the pixel we drew raycast to: ")
							#print("test_right: " + str(test_right))
							#print("the tile pixel we drew raycast from: ")
							#print("pixel: " + str(looker_pos_pixel_center))
						
						if !occlusion_down || (occlusion_down.position - test_down).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							#print("Clearing tile: " + str(Vector2i(x, y)))
							#print("the pixel we drew raycast to: ")
							#print("test_down: " + str(test_down))
							#print("the tile pixel we drew raycast from: ")
							#print("pixel: " + str(looker_pos_pixel_center))
							
						if !occlusion_left || (occlusion_left.position - test_left).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							#print("Clearing tile: " + str(Vector2i(x, y)))
							#print("the pixel we drew raycast to: ")
							#print("test_left: " + str(test_left))
							#print("the tile pixel we drew raycast from: ")
							#print("pixel: " + str(looker_pos_pixel_center))
							
						if !occlusion_up || (occlusion_up.position - test_up).length() < 1:
							_fog_tile_layer.erase_cell(Vector2i(x, y))
							#print("Clearing tile: " + str(Vector2i(x, y)))
							#print("the pixel we drew raycast to: ")
							#print("test_up: " + str(test_up))
							#print("the tile pixel we drew raycast from: ")
							#print("pixel: " + str(looker_pos_pixel_center))
					
					#Now if we've done that previous check, we do this.
					#This if statement is redundant and can be put into the above if statement
					#but this whole mini-function for the corner edge cases is kind of gross so I'm keeping it away from the other one
					if(tile_collision_polygons == null):
						
						#We need to check the 8 tiles around the tile we're testing for information.
						#We get:
						#the 8 cells' tile data from the current map to check for walls
						#and
						#the 8 cells' source id from the current fog map to check for already cleared vision
						test_tile_data_east = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(1, 0)))
						test_tile_data_south = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(0, 1)))
						test_tile_data_west = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(-1, 0)))
						test_tile_data_north = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(0, -1)))
						
						test_tile_data_south_east = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(1, 1)))
						test_tile_data_north_east = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(1, -1)))
						test_tile_data_south_west = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(-1, 1)))
						test_tile_data_north_west = (map_tile_map_layer.get_cell_tile_data(Vector2(x, y) + Vector2(-1, -1)))
						
						adjacent_fog_east = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(1, 0))
						adjacent_fog_south = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(0, 1))
						adjacent_fog_west = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(-1, 0))
						adjacent_fog_north = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(0, -1))
						
						adjacent_fog_south_east = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(1, 1))
						adjacent_fog_north_east = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(1, -1))
						adjacent_fog_south_west = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(-1, 1))
						adjacent_fog_north_west = _fog_tile_layer.get_cell_source_id(Vector2i(x, y) + Vector2i(-1, -1))
						
						#test prints for specific tiles on starting well
						#if(Vector2(x, y) == Vector2(7, 0)):
							#if(test_tile_data_east != null):
								#print("test_tile_data_east " + str(test_tile_data_east))
							#if(test_tile_data_south != null):
								#print("test_tile_data_south " + str(test_tile_data_south))
							#if(test_tile_data_west != null):
								#print("test_tile_data_west " + str(test_tile_data_west))
							#if(test_tile_data_north != null):
								#print("test_tile_data_north " + str(test_tile_data_north))
						
						#Now we test for every edge case for corners.
						#If two tiles are walls
						#and diagonal to each other 
						#and share an adjacent tile other than the tile we're checking
						#and that shared adjacent tile is not a wall
						#We clear the shared adjacent tile
						#This allows the player to see through a diagonally connected wall.
						if (test_tile_data_east != null and test_tile_data_south != null and adjacent_fog_south_east != null):
							if(test_tile_data_east.get_collision_polygons_count(0) > 0 and test_tile_data_south.get_collision_polygons_count(0) > 0 and test_tile_data_south_east == null and adjacent_fog_east == -1 and adjacent_fog_south == -1 and adjacent_fog_south_east == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								#print("Clearing tile: " + str(Vector2i(x, y)))
								#print("corner exception")
						if (test_tile_data_south != null and test_tile_data_west != null and adjacent_fog_south_west != null):
							if(test_tile_data_south.get_collision_polygons_count(0) > 0 and test_tile_data_west.get_collision_polygons_count(0) > 0 and test_tile_data_south_west == null and adjacent_fog_south == -1 and adjacent_fog_west == -1 and adjacent_fog_south_west == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								#print("Clearing tile: " + str(Vector2i(x, y)))
								#print("corner exception")
						if (test_tile_data_west != null and test_tile_data_north != null and adjacent_fog_north_west != null):
							if(test_tile_data_west.get_collision_polygons_count(0) > 0 and test_tile_data_north.get_collision_polygons_count(0) > 0 and test_tile_data_north_west == null and adjacent_fog_west == -1 and adjacent_fog_north == -1 and adjacent_fog_north_west == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								#print("Clearing tile: " + str(Vector2i(x, y)))
								#print("corner exception")
						if (test_tile_data_north != null and test_tile_data_east != null and adjacent_fog_north_east != null):
							if(test_tile_data_north.get_collision_polygons_count(0) > 0 and test_tile_data_east.get_collision_polygons_count(0) > 0 and test_tile_data_north_east == null and adjacent_fog_north == -1 and adjacent_fog_east == -1 and adjacent_fog_north_east == -1):
								_fog_tile_layer.erase_cell(Vector2i(x, y))
								#print("Clearing tile: " + str(Vector2i(x, y)))
								#print("corner exception")

extends Node

var pixel_center: Vector2
var tile: Vector2

#func converts tile coordinates to pixel center coordinates
func _tile_to_pixel_center(input_tile_coords: Vector2):
	var _x2 = 8 + (input_tile_coords.x * 16)
	var _y2 = 8 + (input_tile_coords.y * 16)
	pixel_center = Vector2(_x2, _y2)
	return pixel_center
	
#_pixel_center_to_tile converts pixel center coordinates to tile coordinates
func _pixel_center_to_tile(input_pixel_center_coords: Vector2):
	var _x2 = (input_pixel_center_coords.x - 8) / 16
	var _y2 = (input_pixel_center_coords.y - 8) / 16
	tile = Vector2(_x2, _y2)
	return tile

#to be commented
func _spawn(scene, pos):
	var iscene = scene.instantiate()
	add_child(iscene)
	iscene.position = pos
	return iscene

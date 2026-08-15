extends Node

var pixel_center: Vector2

func _tile_to_pixel_center(x1, y1):
	var x2 = 8 + (x1 * 16)
	var y2 = 8 + (y1 * 16)
	var pixel_center = Vector2(x2, y2)
	return pixel_center

func _spawn(scene, pos):
	var iscene = scene.instantiate()
	add_child(iscene)
	iscene.position = pos
	return iscene

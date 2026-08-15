extends Node2D

@export var player: PackedScene
@export var slime: PackedScene
@export var starting_well: PackedScene

func _spawn(scene, pos):
	var iscene = scene.instantiate()
	add_child(iscene)
	iscene.position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn(starting_well, Vector2(0,0))
	_spawn(player, Vector2(24,24))
	_spawn(slime, Vector2(136,136))

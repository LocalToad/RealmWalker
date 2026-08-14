extends Node2D

@export var player: PackedScene
@export var slime: PackedScene
@export var starting_well: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var starting_well = starting_well.instantiate()
	add_child(starting_well)
	var new_player = player.instantiate()
	add_child(new_player)
	new_player.global_position = Vector2(24,24)
	var slime1 = slime.instantiate()
	add_child(slime1)
	slime1.position = Vector2(104,184)
	pass # Replace with function body.

extends Node2D

const starting_well = preload("res://Scenes/starting_well.tscn")
const slime = preload("res://Scenes/Slime.tscn")
const player = preload("res://Scenes/player.tscn")

@export var map: Node2D
@export var tile_size: int = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Hey darling, just so you remember
	## We're trying to order the layers like this
	## 0: Current map
	## 1: Enemies
	## 2: Fog of war
	## 3: Player
	## Don't be afraid to change it if necessary, though c;
	map = lib._spawn(starting_well, Vector2(0,0))
	lib._spawn(slime, Vector2(136,136))
	#fog_map = _spawn(fog_map, Vector2(0,0))
	#slime = _spawn(slime, Vector2(136,136))
	lib._spawn(player, Vector2(24,24))
	

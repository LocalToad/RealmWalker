extends Node2D

@export var player: PackedScene
@export var slime: PackedScene
@export var starting_well: PackedScene

#This is a basic spawner for scenes
#This requires 2 Inputs:
#	scene = Whatever scene your want to spawn
#	pos = Vector2(x, y)
#		This is the position in the scene that you want in to spawn
#This Function Does not output anything
func _spawn(scene, pos):
	#Sets variable iscene to the PackedScene that forms
	#Then it instantiates the scene specified
	var iscene = scene.instantiate()
	#Adds the PackedScene as a Child of the Current Scene
	add_child(iscene)
	#Sets the position of the PackedScene to be where at pos
	iscene.position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Spawns the Starting Well Map
	_spawn(starting_well, Vector2(0,0))
	#Spawns the Player on the Map in the middle of the square cave
	_spawn(player, Vector2(24,24))
	#Spawns the Slime outside in the Abandon Hut
	_spawn(slime, Vector2(136,136))

#This function is constatly running and it will tick the turns forward if the player is ready
func _turn(_delta):
	#checks for player to be ready
	if Global.Player_ready:
		#tick turn 1 forward
		Global.Turn += 1
		#sets a half second timer and waits to progress another turn
		await get_tree().create_timer(0.5).timeout
	if !Global.Player_ready:
		#if the player isnt ready then wait
		pass

extends Node2D

const FOG_MAP = preload("res://Scenes/fog_map.tscn")
const tile_size: Vector2 = Vector2(16,16)
var sprite_node_pos_tween: Tween
var goal_pos: Vector2
var r: bool = false
var cur_pos: Vector2
var face: int = 0
var speed: int = 20
var vision_map_loaded: bool = false

func _ready() -> void:
	await get_tree().process_frame
	cur_pos = global_position
	vision._look(global_position)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_home"):
		face = 1
		_reset()
		$NorthWestArrow.visible = true
	elif Input.is_action_pressed("ui_page_up"):
		face = 3
		_reset()
		$NorthEastArrow.visible = true
	elif Input.is_action_pressed("ui_end"):
		face = 7
		_reset()
		$SouthWestArrow.visible = true
	elif Input.is_action_pressed("ui_page_down"):
		face = 5
		_reset()
		$SouthEastArrow.visible = true
	elif Input.is_action_pressed("ui_up"):
		face = 2
		_reset()
		$NorthArrow.visible = true
	elif Input.is_action_pressed("ui_down"):
		face = 6
		_reset()
		$SouthArrow.visible = true
	elif Input.is_action_pressed("ui_left"):
		face = 8
		_reset()
		$WestArrow.visible = true
	elif Input.is_action_pressed("ui_right"):
		face = 4
		_reset()
		$EastArrow.visible = true
	
	if Input.is_action_just_pressed("ui_accept") and face != 0:
		_find_dir()
		global_position = goal_pos
		cur_pos = goal_pos
		#After every movement, look (in vision.gd)
		vision._look(global_position)
		
func _move(dir: Vector2):
	goal_pos = (dir * tile_size) + cur_pos
	
func _reset():
	if $NorthEastArrow.visible:
		$NorthEastArrow.visible = false
	if $NorthArrow.visible:
		$NorthArrow.visible = false
	if $NorthWestArrow.visible:
		$NorthWestArrow.visible = false
	if $WestArrow.visible:
		$WestArrow.visible = false
	if $SouthWestArrow.visible:
		$SouthWestArrow.visible = false
	if $SouthArrow.visible:
		$SouthArrow.visible = false
	if $SouthEastArrow.visible:
		$SouthEastArrow.visible = false
	if $EastArrow.visible:
		$EastArrow.visible = false
		
func _find_dir():
	if face == 1 and !$nw.is_colliding():
		_move(Vector2(-1,-1))
	elif face == 2 and !$n.is_colliding():
		_move(Vector2(0,-1))
	elif face ==3 and !$ne.is_colliding():
		_move(Vector2(1,-1))
	elif face == 4 and !$e.is_colliding():
		_move(Vector2(1,0))
	elif face == 5 and !$se.is_colliding():
		_move(Vector2(1,1))
	elif face == 6 and !$s.is_colliding():
		_move(Vector2(0,1))
	elif face == 7 and !$sw.is_colliding():
		_move(Vector2(-1,1))
	elif face == 8 and !$w.is_colliding():
		_move(Vector2(-1,0))
	

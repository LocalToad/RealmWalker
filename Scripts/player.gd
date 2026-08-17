extends Node2D

#PARAMS

#Variables

var sprite_node_pos_tween: Tween
var goal_pos: Vector2
var cur_pos: Vector2

#Pre-Set Variables

#When Face is set to 0 that means the player has just loaded the game and they
#have not inputed anything yet
#When Face in set to 1-9 that means the player has seleceted a direction in 
#which they want to move in
var face: int = 0
#This int will be the amount of turns it takes the player to enact their turn
var speed: int = 20
#This is the ticket that the player holds to check against to see if it can move
var wait_turn: int  = 0
#This is just a pointer to the global variable so that we can use it here
var r: bool = Global.Player_ready
var use_mode: bool = false
var dir: Vector2

#This is called as soon as the player is spawned into the game
func _ready() -> void:
	#this waits for what the process function runs in the tree
	await get_tree().process_frame
	#set the cur_pos variable to the global postion so we can edit it without
	#moving the sprite
	cur_pos = global_position

#This is called any time a key is inputed
func _physics_process(_delta: float) -> void:
	if !r:
		if Input.is_action_pressed('use'):
			if use_mode:
				use_mode = false
			else:
				use_mode = true
		#This is going to be for people Who dont have SHIFT pressed
		if !Input.is_action_pressed("alt_move"):
			#checks if nw is pressed
			if Input.is_action_pressed("nw"):
				#sets the face var to a number so we can see where we are pointing
				face = 1
				#this turns off any currently shown arrows
				_reset()
				#this shows the NorthWest Arrow
				$NorthWestArrow.visible = true
			#checks if n is pressed
			elif Input.is_action_pressed("n"):
				face = 2
				_reset()
				$NorthArrow.visible = true
			#checks if ne is pressed
			elif Input.is_action_pressed("ne"):
				face = 3
				_reset()
				$NorthEastArrow.visible = true
			#checks if e is pressed
			elif Input.is_action_pressed("e"):
				face = 4
				_reset()
				$EastArrow.visible = true
			#checks if se is pressed
			elif Input.is_action_pressed("se"):
				face = 5
				_reset()
				$SouthEastArrow.visible = true
			#checks if s is pressed
			elif Input.is_action_pressed("s"):
				face = 6
				_reset()
				$SouthArrow.visible = true
			#checks if sw is pressed
			elif Input.is_action_pressed("sw"):
				face = 7
				_reset()
				$SouthWestArrow.visible = true
			#checks if w is pressed
			elif Input.is_action_pressed("w"):
				face = 8
				_reset()
				$WestArrow.visible = true
			
		#IF the player presses shift they will calculate their desired direction
		#by waiting for a vertical and a horizontal direction to be pressed 
		#while shift is pressed
		
		if Input.is_action_pressed("alt_move"):
			if Input.is_action_just_pressed("n"):
				if face == 8 || face == 7:
					face = 1
					_reset()
					$NorthWestArrow.visible = true
				elif face == 4 || face == 5:
					face = 3
					_reset()
					$NorthEastArrow.visible = true
				else:
					face = 2
					_reset()
					$NorthArrow.visible = true
			if Input.is_action_just_pressed("s"):
				if face == 8 || face == 1:
					face = 7
					_reset()
					$SouthWestArrow.visible = true
				elif face == 4 || face == 3:
					face = 5
					_reset()
					$SouthEastArrow.visible = true
				else:
					face = 6
					_reset()
					$SouthArrow.visible = true
			if Input.is_action_just_pressed("e"):
				if face == 1 || face == 2:
					face = 3
					_reset()
					$NorthEastArrow.visible = true
				elif face == 7 || face == 6:
					face = 5
					_reset()
					$SouthEastArrow.visible = true
				else:
					face = 4
					_reset()
					$EastArrow.visible = true
			if Input.is_action_just_pressed("w"):
				if face == 2 || face == 3:
					face = 1
					_reset()
					$NorthWestArrow.visible = true
				elif face == 6 || face == 5:
					face = 7
					_reset()
					$SouthWestArrow.visible = true
				else:
					face = 8
					_reset()
					$WestArrow.visible = true
					
			
		
		#Checks if the End Turn key has been press 
		#and that the face var is set to a direction
		if Input.is_action_just_pressed("end_turn") and face != 0:
			#check if we are colliding with anything and set our goal pos if not
			dir = _find_dir()
			#lets the game know that the player is ready for turns to pass
			r = true
	elif r:
		if wait_turn == Global.Turn:
			#lets the game know that it is the players to and to wait for an input
			r = false
			if !use_mode:
				_move(dir)
				#set global position to the goal position generated in _find_dir
				global_position = goal_pos
				#updates our cur_pos with the goal_pos
				cur_pos = goal_pos
			
			
#This updates the goal_pos
#This Requires 1 input:
#	dir = Vector2 = multiplyer for direction
func _move(dir: Vector2):
	#updates the goal_pos
	goal_pos = (dir * Global.Tile_size) + cur_pos
	
#This function turns off all visible arrows
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
		
#This function checks if we are colliding in the direction the player has input
func _find_dir():
	#check face for direction, then check if colliding
	if face == 1 and !$nw.is_colliding():
		#run the _move math function with the needed direction data to update goal_pos
		return Vector2(-1,-1)
	elif face == 2 and !$n.is_colliding():
		return Vector2(0,-1)
	elif face ==3 and !$ne.is_colliding():
		return Vector2(1,-1)
	elif face == 4 and !$e.is_colliding():
		return Vector2(1,0)
	elif face == 5 and !$se.is_colliding():
		return Vector2(1,1)
	elif face == 6 and !$s.is_colliding():
		return Vector2(0,1)
	elif face == 7 and !$sw.is_colliding():
		return Vector2(-1,1)
	elif face == 8 and !$w.is_colliding():
		return Vector2(-1,0)

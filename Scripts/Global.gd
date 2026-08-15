extends Node

#This is going to be a big file of variables that scripts will be looking at
#or editing often

#This is the tile size of the entire game
const Tile_size: Vector2 = Vector2(16,16)
#This is the Current Turn the game is on
var Turn: int = 0
#This is tells us if the player is ready for the game to progress 
#or if we need to wait for more inputs from the player
var Player_ready: bool = false

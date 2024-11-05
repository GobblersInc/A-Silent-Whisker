extends Object

# list of input types and their category 
var movement = ["move_up", "move_down", "move_left", "move_right", "move_fast"]
var pause = "pause"

func _input(event: InputEvent) -> void:
	if 
	
	
#input manager
#
#listens to player input
#sends signals to areas depending on what player pressed?
#
#current signals we are working with
#movement signals (wasd arrow keys, c shft, ctrl)
#Escape
#
#(dont forget mouse movement)
#
#anytime input is recieved needs to check
#> is it escape?
  #> send signal to pause/unpause the game
#> is it movement?
  #> send the type of movement to the player script

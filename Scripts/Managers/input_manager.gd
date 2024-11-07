extends Object

# list of input types and their category 

signal Movement()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_fast") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up"):
		Movement.emit()
	
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

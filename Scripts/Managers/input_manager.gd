extends Node

# list of input types and their category 

signal Movement()
signal benis(state, text)

@onready var dialog_manager = get_node("/root/DialogManager")

var paralyzed = false

func _ready() -> void:
	dialog_manager.connect("dialog_update", _on_dialog_update)
	
func _on_dialog_update(state: bool):
	paralyzed = state

var is_vis = false

func _input(event: InputEvent) -> void:
	# Ignore input if player needs to be still (ex: reading dialog)
	if Input.is_action_just_pressed("test"):
		if is_vis:
			benis.emit(false, "")
			is_vis = false
		else:
			is_vis = true
			benis.emit(true, "idk")
	
	if paralyzed:
		# They can press the interact button to break out of it.
		if Input.is_action_pressed("interact"):
			paralyzed = false
		return
	
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

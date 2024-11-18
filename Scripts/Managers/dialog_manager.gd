extends Control

signal dialog_update(state, text)

@onready var input_manager = get_node("/root/InputManager")

func _ready():
	input_manager.connect("benis", _on_benis)

func _on_benis(state, text: String = ""):
	print("BENIS CHECK")
	print(state)
	dialog_update.emit(state, text)

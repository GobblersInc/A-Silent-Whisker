extends Control

signal dialog_update(state, text)

@onready var input_manager = get_node("/root/InputManager")

func _ready():
	input_manager.connect("benis", _on_benis)
	hide()  # Initially hide the dialog box

func _on_benis(state, text: String = ""):
	print("BENIS CHECK")
	dialog_update.emit(state, text)

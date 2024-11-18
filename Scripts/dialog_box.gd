extends Control

@onready var dialog_manager = get_node_or_null("/root/DialogManager")

func show_dialog(text: String):
	$Panel/Label.text = text
	show()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dialog_manager:
		dialog_manager.connect("dialog_update", _on_dialog_update)

func _on_dialog_update(state, text):
	if state:
		show_dialog(text)  # Hide the dialog box
	else:
		hide()

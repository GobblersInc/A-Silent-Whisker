extends Control

var is_visible = false
@onready var dialog_manager = get_node("root/DialogManager")

func show_dialog(text: String):
	$Panel/Label.text = text
	show()
	is_visible = true
	
func hide_dialog():
	hide()  # Hide the dialog box
	is_visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog_manager.connect("dialog_update", _on_dialog_update)

func _on_dialog_update(state, text):
	if state:
		show_dialog(text)  # Hide the dialog box

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

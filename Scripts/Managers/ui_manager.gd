extends Control

@onready var _SettingsScreen = $SettingsControl

func _ready():
	_SettingsScreen.hide()
	
func _input(event):
	if event.is_action_pressed("esc_pause"):
		if (get_tree().paused):
			_Unpause()
		else:
			_Pause()
	
func _Pause():
	get_tree().set_pause(true)
	_SettingsScreen.show()
	
func _Unpause():
	get_tree().set_pause(false) 
	_SettingsScreen.hide()
	

extends Control

@onready var _SettingsScreen = $SettingsControl
@onready var _Player = $Player

var combine_name =  "player_name" + str(randi_range(1, 10000000))

func _ready():
	_SettingsScreen.hide()
	
func _input(event):
	if event.is_action_pressed("esc_pause"):
		if (get_tree().paused):
			_Unpause()
		else:
			_Pause()
	#if event.is_action_pressed("save_game"):
		#SaveManager.save_game(combine_name, _Player)
	#if event.is_action_pressed("load_game"):
		#SaveManager.save_game(combine_name, _Player)
	
func _Pause():
	get_tree().set_pause(true)
	_SettingsScreen.show()
	
func _Unpause():
	get_tree().set_pause(false) 
	_SettingsScreen.hide()
	

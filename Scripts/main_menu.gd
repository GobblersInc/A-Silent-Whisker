extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	print("Start button pressed") 

func _on_continue_button_pressed():
	print("Continue button pressed") 

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/SettingMenu.tscn")
	print("Options button pressed") 


#Test main menu audio
#func _ready():
#	audio_manager.play_audio("TestMusic")

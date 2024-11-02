extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	print("Start button pressed") 

func _on_continue_button_pressed():
	print("Continue button pressed") 

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/optionsmenu.tscn")
	print("Options button pressed") 

extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	print("Start button pressed") 

func _on_continue_button_pressed():
	print("Continue button pressed") 

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings_menu.tscn")
	print("Options button pressed") 

#Test main menu audio
#func _ready():
	##This is temp janky method for presetting volume within each bus
	##Needs to be replaced unless jank is the way
	#audio_manager.set_bus_volume(Busses.MUSIC, 0.5)
	#audio_manager.set_bus_volume(Busses.SFX, 0.5)
	#audio_manager.set_bus_volume(Busses.WEATHER, 0.5)
	#audio_manager.set_bus_volume(Busses.MASTER, 0.5)
	#
	#audio_manager.play_sound("TestMusic")

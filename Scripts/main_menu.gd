extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	print("Start button pressed") 

func _on_continue_button_pressed():
	print("Continue button pressed") 

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
	print("Options button pressed") 

#Test main menu audio
func _ready():
	var preset_volume = linear_to_db(0.5)
	
	#This is temp janky method for presetting volume within each bus
	#Needs to be replaced unless jank is the way
	audio_manager.set_bus_volume(Busses.MUSIC, preset_volume)
	audio_manager.set_bus_volume(Busses.SFX, preset_volume)
	audio_manager.set_bus_volume(Busses.WEATHER, preset_volume)
	audio_manager.set_bus_volume(Busses.MASTER, preset_volume)
	
	audio_manager.play_audio("TestMusic")

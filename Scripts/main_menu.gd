extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_continue_button_pressed():
	print("Continue button pressed") 

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings_menu.tscn")

func _ready():
	#This is temp janky method for presetting volume within each bus
	#Needs to be replaced unless jank is the way
	AudioManager.set_bus_volume(Busses.MUSIC, 0.3)
	AudioManager.set_bus_volume(Busses.SFX, 0.3)
	AudioManager.set_bus_volume(Busses.WEATHER, 0.5)
	AudioManager.set_bus_volume(Busses.MASTER, 0.4)
	#
	AudioManager.play_group("BG_MUSIC", true, true, true)
	#audio_manager.play_group("CITY_SOUNDS", true, true, true)

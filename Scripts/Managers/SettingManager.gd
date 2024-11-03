extends Control

var option_config = ConfigFile.new()
var config_path = "res://ProjectSettings/option_settings.cfg"
var sound_section = "VOLUMES"
var music_volume = 50
var sound_volume = 50

signal music_signal(arg : int)
signal sound_signal(arg : int)

@onready var music_slider := $OptionsBackground/MarginContainer/VBoxContainer/GameSoundHSlider
@onready var sound_slider := $OptionsBackground/MarginContainer/VBoxContainer/MusicHSlider

#Look into Audio buses for updating volume with sliders 
#Figure out button fonts and fonts for this Menu in general
#Continue UI Overlay migration

func _ready():
	# load_settings()
	music_slider.value = music_volume
	sound_slider.value = sound_volume

#Figure out later
func load_settings():
	var err = option_config.load(config_path)

	if err == OK:
		music_volume = option_config.get_value(sound_section, "music_volume")
		sound_volume = option_config.get_value(sound_section, "sound_volume")
	else:
		music_volume = 50
		sound_volume = 50
		
func save_settings():
	var err = option_config.save(config_path)
	
	if err != OK:
		print("Unable to save settings configuration!")
		
func _on_back_button_pressed():
	print("Back button pressed")
	save_settings() 

func _on_exit_button_pressed():
	print("Exit button pressed")
	save_settings()
	get_tree().quit()

# Need to set as an event for sound Manager to check
func _on_music_h_slider_value_changed(value):
	print("Music has been changed to: " + str(value))
	music_volume = value
	music_signal.emit(music_volume)
	
	option_config.set_value(sound_section, "music_volume", music_volume)

# Need to set as an event for sound Manager to check
func _on_game_sound_h_slider_value_changed(value):
	print("Sound has been changed to: " + str(value))
	sound_volume = value
	sound_signal.emit(sound_volume)
	
	option_config.set_value(sound_section, "sound_volume", sound_volume)

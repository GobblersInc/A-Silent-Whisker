extends Control

@onready var music_slider := $SettingsBackground/MarginContainer/SVBoxContainer/MusicHSlider
@onready var sfx_slider := $SettingsBackground/MarginContainer/SVBoxContainer/SfxHSlider
@onready var weather_slider := $SettingsBackground/MarginContainer/SVBoxContainer/WeatherHSlider
@onready var master_slider := $SettingsBackground/MarginContainer/SVBoxContainer/MasterHSlider
@onready var player = $"../.."

var setting_config = ConfigFile.new()
var config_path = "res://ProjectSettings/settings_config.cfg"
var sound_section = "VOLUMES"

var player_name = "player_name"
var combine = ""

# audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
var volumes = {
	"music": 50,
	"sfx": 50,
	"weather": 50,
	"master": 50,
}

func _ready():
	music_slider.value = volumes["music"]
	sfx_slider.value = volumes["sfx"]
	weather_slider.value = volumes["weather"]
	master_slider.value = volumes["master"]
	
	combine = player_name + str(randi_range(1, 10000000))

# Can only use values between 0.0 to 1.0 for linear value
# Otherwise values past 1, will result in n*maximum volume limit (AKA: You going to blow out your ear drums)
func convert_to_audio(slider, value):
	var linear = value / 100
	audio_manager.set_bus_volume(slider, linear)

func _on_save_button_pressed():
	save_manager.save_game(combine, player)

func _on_reload_button_pressed():
	save_manager.load_game(combine, player)

func _on_back_button_pressed():
	print("Back button pressed")
	
func _on_main_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_music_h_slider_value_changed(value):
	convert_to_audio(Busses.MUSIC, value)

func _on_sfx_h_slider_value_changed(value):
	convert_to_audio(Busses.SFX, value)

func _on_master_h_slider_value_changed(value):
	convert_to_audio(Busses.MASTER, value)

func _on_weather_h_slider_value_changed(value):
	convert_to_audio(Busses.WEATHER, value)

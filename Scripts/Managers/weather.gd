extends Node

@onready var weather_array: Array = [Weather_Types.RAIN, Weather_Types.SNOW, Weather_Types.SUN, Weather_Types.WIND]
@onready var rain_effect: GPUParticles2D = $"../Rain"
@onready var snow_effect: GPUParticles2D = $"../Snow"
@onready var wind_effect: GPUParticles2D = $"../Wind"
@onready var sun_effect: WorldEnvironment = $"../Sun"
var current_weather: String
var stream_player: AudioStreamPlayer

func _ready():
	randomize()
	weather_select()

func weather_select():
	current_weather = weather_array[randi_range(0,weather_array.size()-1)]
	stop_weather_anim()
	weather_sound_select()
	match current_weather:
		Weather_Types.RAIN:
			rain()
			await wait(randf_range(20.0,40.0))
			weather_select()
		Weather_Types.SNOW:
			snow()
			await wait(randf_range(20.0,40.0))
			weather_select()
		Weather_Types.SUN:
			sun()
			await wait(randf_range(20.0,40.0))
			weather_select()
		Weather_Types.WIND:
			wind()
			await wait(randf_range(20.0,40.0))
			weather_select()
		
func weather_sound_select():
	stop_weather_sound()
	match current_weather:
		Weather_Types.RAIN:
			stream_player = audio_manager.play_group("WEATHER_RAIN", true, true, true)
		Weather_Types.SNOW:
			stream_player = audio_manager.play_group("WEATHER_SNOW", true, true, true)
		Weather_Types.SUN:
			stream_player = audio_manager.play_group("CITY_SOUNDS", true, true, true)
		Weather_Types.WIND:
			stream_player = audio_manager.play_group("WEATHER_WIND", true, true, true)

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func rain():
	rain_effect.amount = (randi_range(300, 700))
	rain_effect.speed_scale = (randi_range(1, 2))
	rain_effect.emitting = true
	
func snow():
	snow_effect.amount = (randi_range(200, 1200))
	snow_effect.speed_scale = (randi_range(1, 3))
	snow_effect.emitting = true
	
func sun():
	sun_effect.environment.glow_enabled = true
	
func wind():
	wind_effect.amount = (randi_range(2, 5))
	wind_effect.speed_scale = (randi_range(1, 2))
	wind_effect.emitting = true

func stop_weather_anim():
	rain_effect.emitting = false
	snow_effect.emitting = false
	sun_effect.environment.glow_enabled = false
	wind_effect.emitting = false

func stop_weather_sound():
	if stream_player != null:
		var tween = get_tree().create_tween()
		tween.tween_property(stream_player,"volume_db", linear_to_db(0), 4)
		await tween.finished

extends Node

@onready var weather_array: Array = [Weather_Types.RAIN, Weather_Types.SNOW, Weather_Types.SUN, Weather_Types.WIND]
@onready var rain_effect: GPUParticles2D = $"../Rain"
@onready var snow_effect: GPUParticles2D = $"../Snow"
@onready var wind_effect: GPUParticles2D = $"../Wind"
@onready var sun_effect: WorldEnvironment = $"../Sun"
var current_weather: String
var previous_weather: String
var stream_player: AudioStreamPlayer

func _ready():
	randomize()
	weather_select()

func weather_select():
	if current_weather != null:
		previous_weather = current_weather
	current_weather = weather_array[randi_range(0, weather_array.size()-1)]
	await stop_weather_anim()
	weather_sound_select()
	match current_weather:
		Weather_Types.RAIN:
			rain()
			await wait(randf_range(30.0,60.0))
			weather_select()
		Weather_Types.SNOW:
			snow()
			await wait(randf_range(30.0,60.0))
			weather_select()
		Weather_Types.SUN:
			sun()
			await wait(randf_range(30.0,60.0))
			weather_select()
		Weather_Types.WIND:
			wind()
			await wait(randf_range(30.0,60.0))
			weather_select()
		
func weather_sound_select():
	if current_weather != previous_weather:
		stop_weather_sound()
		match current_weather:
			Weather_Types.RAIN:
				stream_player = AudioManager.play_group("WEATHER_RAIN", true, true, true)
			Weather_Types.SNOW:
				stream_player = AudioManager.play_group("WEATHER_SNOW", true, true, true)
			Weather_Types.SUN:
				stream_player = AudioManager.play_group("CITY_SOUNDS", true, true, true)
			Weather_Types.WIND:
				stream_player = AudioManager.play_group("WEATHER_WIND", true, true, true)

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func rain():
	if current_weather != previous_weather:
		var new_rain_amount = (randf_range(300.0, 2000.0))
		var new_rain_scale = (randf_range(1.0, 2.0))
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(rain_effect, "amount_ratio", (new_rain_amount/rain_effect.amount), 3)
		tween.parallel().tween_property(rain_effect, "speed_scale", new_rain_scale, 3)
	else:
		var new_rain_amount = (randf_range(300.0, 2000.0))
		var new_rain_scale = (randf_range(1.0, 2.0))
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(rain_effect, "amount_ratio", (new_rain_amount/rain_effect.amount), 3)
		tween.parallel().tween_property(rain_effect, "speed_scale", new_rain_scale, 3)
	
func snow():
	if current_weather != previous_weather:
		var new_snow_amount = (randf_range(300.0, 2000.0))
		var tween = get_tree().create_tween()
		tween.tween_property(snow_effect, "amount_ratio", (new_snow_amount/snow_effect.amount), 3)
	else:
		var new_snow_amount = (randf_range(300.0, 2000.0))
		var tween = get_tree().create_tween()
		tween.tween_property(snow_effect, "amount_ratio", (new_snow_amount/snow_effect.amount), 3)
	
func sun():
	if current_weather != previous_weather:
		var tween = get_tree().create_tween()
		tween.tween_property(sun_effect.environment, "glow_intensity", randf_range(0.50, 1.00), 3)
	
func wind():
	if current_weather != previous_weather:
		var new_wind_amount = (randf_range(3.0, 8.0))
		var new_wind_scale = (randf_range(1.0, 2.0))
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(wind_effect, "amount_ratio", (new_wind_amount/wind_effect.amount), 3)
		tween.parallel().tween_property(wind_effect, "speed_scale", new_wind_scale, 3)
	else:
		var new_wind_amount = (randf_range(3.0, 8.0))
		var new_wind_scale = (randf_range(1.0, 2.0))
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(wind_effect, "amount_ratio", (new_wind_amount/wind_effect.amount), 3)
		tween.parallel().tween_property(wind_effect, "speed_scale", new_wind_scale, 3)
		

func stop_weather_anim():
	if current_weather != null:
		if current_weather != previous_weather:
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(rain_effect, "amount_ratio", 0.0, 3)
			tween.parallel().tween_property(snow_effect, "amount_ratio", 0.0, 3)
			tween.parallel().tween_property(wind_effect, "amount_ratio", 0.0, 3)
			tween.parallel().tween_property(sun_effect.environment, "glow_intensity", 0.0, 3)

func stop_weather_sound():
	if stream_player != null:
		var tween = get_tree().create_tween()
		tween.tween_property(stream_player,"volume_db", -80.0, 4)
		await tween.finished
		#currently not fading out of sound.

extends Node

@onready var weather_array: Array = [Weather_Types.RAIN, Weather_Types.SNOW, Weather_Types.SUN, Weather_Types.WIND]

@onready var weather_sounds_groups: Dictionary = {
	"Rain" : "WEATHER_RAIN", 
	"Snow" : "WEATHER_SNOW", 
	"Sun" : "CITY_SOUNDS", 
	"Wind" : "WEATHER_WIND"
	}

@onready var rain_effect: GPUParticles2D = $"../Rain"
@onready var snow_effect: GPUParticles2D = $"../Snow"
@onready var sun_effect: WorldEnvironment = $"../Sun"
@onready var wind_effect: GPUParticles2D = $"../Wind"

@onready var weather_effects: Dictionary = {
	"Rain" : rain_effect, 
	"Snow" : snow_effect, 
	"Sun" : sun_effect, 
	"Wind" : wind_effect
	}
	
var current_weather: Array[String]
var queued_weather: Array[String]
var common_weather: Array[String]
var discontinued_weather: Array[String]
var newly_started_weather: Array[String]
var giga: bool = false
var noweather: bool = false


# Seed weather; start weather loop
func _ready():
	randomize()
	roll_new_weather()

# Exterior facing function - sets weather, tweens out previous weather + sound, tweens in new weather + sound.
func set_weather(weather: Array[String], intensity: Array[float], speed: Array[int], duration: int, override: bool = false):
	# Weather array - List of requested weathers with a max of 2 types that conform to Weather_Types.Valid_Weather_Pairs. If given an empty Array, will process as no weather.
	# Intensity - min value of 0.01, max value of 1.00
	# Speed - min value of 1, max value of 3
	# Duration - seconds of weather, 0 = infinite
	if noweather == true:
		current_weather.clear()
		weather.clear()
	else:
		if not weather.is_empty():
			queued_weather = weather.duplicate(true)
			# Compare current weather array to new weather array, finds commonalities and differences, splits them into 3 arrays (common, discontinued, and newly_started)
			_weather_change_preparation()
			current_weather = weather.duplicate(true)
			# Iterate through common_weather, tweening from existing values to new values of intensity and speed.
			var count := 0
			if not common_weather.is_empty():
				for index in common_weather:
					var tween = get_tree().create_tween()
					if index == "Sun":
						tween.parallel().tween_property(sun_effect.environment, "glow_intensity", intensity[count-1], 3)
					else:
						tween.parallel().tween_property(weather_effects[index], "amount_ratio", intensity[count-1], 3)
						tween.parallel().tween_property(weather_effects[index], "speed_scale", speed[count-1], 3)
					count += 1
			count = 0
			# Iterate through discontinued_weather, shutting off weather + sounds.
			if not discontinued_weather.is_empty():
				for index in discontinued_weather:
					var tween = get_tree().create_tween()
					if index == "Sun":
						tween.parallel().tween_property(sun_effect.environment, "glow_intensity", 0.15, 3)
						AudioManager.stop_group("CITY_SOUNDS", true)
					else:
						tween.parallel().tween_property(weather_effects[index], "amount_ratio", 0, 3)
						tween.parallel().tween_property(weather_effects[index], "speed_scale", 1, 3)
						AudioManager.stop_group(weather_sounds_groups[index], true)
						await get_tree().create_timer(3).timeout
						weather_effects[index].emitting = false
					count += 1
			count = 0
			# Iterate through newly_started_weather, turning on new weather + sounds.
			if not newly_started_weather.is_empty():
				for index in newly_started_weather:
					var tween = get_tree().create_tween()
					if index == "Sun":
						tween.parallel().tween_property(sun_effect.environment, "glow_intensity", intensity[count-1], 3)
						AudioManager.play_group("CITY_SOUNDS", true, true, true)
					else:
						weather_effects[index].amount_ratio = 0
						weather_effects[index].emitting = true
						tween.parallel().tween_property(weather_effects[index], "amount_ratio", intensity[count-1], 3)
						tween.parallel().tween_property(weather_effects[index], "speed_scale", speed[count-1], 3)
						AudioManager.play_group(weather_sounds_groups[index], true, true, true)
					count += 1
			# If duration given to function is 0, given weather will persist indefinitely until given another set of entries.
			if duration == 0:
				pass
			# If 5th variable (override: bool) given to function is true, another weather roll will not occur. This would normally only occur when the duration given is 0 and the weather should run indefinitely.
			elif !override:
				await get_tree().create_timer(duration).timeout
				roll_new_weather()

# Function to parse the current_weather + queued_weather, returning common_weather, discontinued_weather, and newly_started_weather.
func _weather_change_preparation():
	common_weather.clear()
	discontinued_weather.clear()
	newly_started_weather.clear()
	if not current_weather.is_empty():
		for c_weather in current_weather:
			if c_weather in queued_weather:
				common_weather.append(c_weather)
			else:
				discontinued_weather.append(c_weather)
		for q_weather in queued_weather:
			if q_weather not in current_weather:
				newly_started_weather.append(q_weather)
	else:
		newly_started_weather = queued_weather.duplicate(true)

# Function for rolling new weather type, intensity, speed, and duration.
func roll_new_weather():
	var new_weather: Array[String]
	# % chance of 1 or 2 weather types.
	if randi_range(1, 100) >= 20:
		new_weather.clear()
		new_weather.append(weather_array.pick_random())
	else:
		# Selecting a valid weather duo
		new_weather = (Weather_Types.Valid_Weather_Pairs).pick_random().duplicate(true)
	var intensity: Array[float]
	for i in range(new_weather.size()):
		if giga == true:
			intensity.append(randf_range(0.85, 1.0))
		else:	
			intensity.append(randf_range(0.2, 0.3))
	var speed: Array[int]
	for i in range(new_weather.size()):
		if giga == true:
			speed.append(randi_range(2, 3))
		else:
			speed.append(randi_range(1, 2))
	var duration: int = (randi_range(5, 15))
	set_weather(new_weather, intensity, speed, duration, false)

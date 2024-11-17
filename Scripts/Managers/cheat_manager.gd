extends Node

@onready var player = $"../Player"
@onready var cheat_entry: LineEdit = $"../Player/OverlayUIControl/SettingsControl/SettingsBackground/MarginContainer/BVBoxContainer/CheatEntry"
@onready var weather: Node = $"../Player/WeatherControlNode"
@onready var player_camera: Camera2D = $"../Player/Camera2D"
@onready var player_sprite: AnimatedSprite2D = $"../Player/AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_cheat_entry_text_submitted(_new_text):
	var text: String = cheat_entry.text.strip_edges()
	text = text.to_lower()
	cheat_entry.clear()
	match text:
		"gigaweather":
			match weather.current_weather:
				Weather_Types.RAIN:
					var tween = get_tree().create_tween()
					tween.parallel().tween_property(weather.rain_effect, "amount_ratio", 1, 2)
					tween.parallel().tween_property(weather.rain_effect, "speed_scale", 3, 2)
				Weather_Types.SNOW:
					var tween = get_tree().create_tween()
					tween.parallel().tween_property(weather.snow_effect, "amount_ratio", 1, 2)
					tween.parallel().tween_property(weather.snow_effect, "speed_scale", 3, 2)
				Weather_Types.SUN:
					var tween = get_tree().create_tween()
					tween.parallel().tween_property(weather.sun_effect.environment, "glow_intensity", 0.90, 2)
				Weather_Types.WIND:
					var tween = get_tree().create_tween()
					tween.parallel().tween_property(weather.wind_effect, "amount_ratio", 1, 2)
					tween.parallel().tween_property(weather.wind_effect, "speed_scale", 3, 2)
		"ezhop":
			player.max_wall_jumps = 2
		"cybernetics":
			player.max_wall_jumps = 4
			player.coyote_time_duration = 0.500
		"hangtime":
			player.coyote_time_duration = 0.250
		"superbounce":
			player.jump_speed = -400
			player.wall_jump_speed = -620
		"lowgrav":
			player.fall_speed = 490
		"nocheats":
			weather.weather_select()
			if weather.rain_effect.emitting == false:
				weather.rain_effect.emitting = true
				weather.snow_effect.emitting = true
				weather.wind_effect.emitting = true
				var tween = get_tree().create_tween()
				tween.parallel().tween_property(weather.sun_effect.environment, "glow_intensity", 0.15, 2)
			player.max_wall_jumps = 1
			player.coyote_time_duration = 0.125
			player.jump_speed = -200
			player.wall_jump_speed = -300
			player.fall_speed = 980
			player.inverted = false
			weather.sun_effect.environment.adjustment_saturation = 1.0
			player.jeb = false
			player_camera.zoom.x = 1
			player_camera.zoom.y = 1
		"noweather":
			weather.rain_effect.emitting = false
			weather.snow_effect.emitting = false
			weather.wind_effect.emitting = false
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(weather.sun_effect.environment, "glow_intensity", 0.15, 2)
			weather.stop_weather_sound()
		"inverted":
			player.inverted = true
		"grayscale":
			weather.sun_effect.environment.adjustment_saturation = 0.0
		"jeb":
			player.jeb = true
		"invertedcamera":
			player_camera.zoom.x *= -1
			player_camera.zoom.y *= -1

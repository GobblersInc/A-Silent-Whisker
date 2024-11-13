extends Node

@onready var _busses: Busses = Busses.new()

var _audio_definitions: Dictionary = {}
var _audio_groups: Array[AudioGroup] = []

var _path_to_audio_definitions: String = "res://Resources/Configurations/audio_definitions.json"

func _ready():
	_load_audio_definitions(_path_to_audio_definitions)

# Load definitions from JSON
func _load_audio_definitions(file_path: String):
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			var data: Dictionary = json.data
			for audio_name in data["audio_files"]:
				var details: Dictionary = data["audio_files"][audio_name]
				var audio_def: AudioDefinition = AudioDefinition.new(audio_name, details["bus"], details["group"], details["path"])
				_audio_definitions[audio_name] = audio_def
		else:
			push_error("Failed to parse JSON: %s" % parse_result.error_string)
	else:
		push_error("Failed to load audio definitions from file: %s" % file_path)

# Get or load sound using AudioDefinition
func _get_audio_definition(audio_name: String) -> AudioDefinition:
	return _audio_definitions.get(audio_name, null)

# Get all sounds by group
func _get_sounds_by_group(group_name: String) -> Array:
	return _audio_definitions.values().filter(func(audio_def): return audio_def.group == group_name)

# Set bus volume
func set_bus_volume(bus_name: String, volume: float):
	_busses.set_bus_volume(bus_name, volume)
	
func play_sound(sound_name: String, should_loop: bool = false):
	var audio_definition: AudioDefinition = _get_audio_definition(sound_name)
	var audio_definition_array: Array = [audio_definition]
	var audio_group = AudioGroup.new(sound_name, AudioStreamManager.new(AudioPlayerPool.get_player()), Playlist.new(audio_definition_array, false, false, should_loop))
	_audio_groups.append(audio_group)
	
	audio_group.play()
	
	return audio_group

func play_group(group_name: String, should_play_all_group: bool, should_be_random: bool, should_loop: bool):
	var audio_group_array: Array = _get_sounds_by_group(group_name)
	var audio_group = AudioGroup.new(group_name, AudioStreamManager.new(AudioPlayerPool.get_player()), Playlist.new(audio_group_array, should_play_all_group, should_be_random, should_loop))
	
	_audio_groups.append(audio_group)
	
	audio_group.play()
	
	return audio_group

func stop_group(group_name: String, stop_all: bool):
	for i in range(_audio_groups.size()):
		var audio_group = _audio_groups[i]
		
		# Check if the group's name matches the specified group name
		if audio_group.group_name == group_name:
			# Dispose of the player in the AudioStreamManager
			audio_group.audio_stream_manager.dispose_audio_player()

			# Remove the group from the _audio_groups list
			_audio_groups.remove_at(i)
			i -= 1  # Adjust index after removal

			# If stop_all is false, stop after the first match
			if not stop_all:
				break

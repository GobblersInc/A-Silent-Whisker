extends Node

var _audio_definitions: Dictionary = {}
var _player_pool: Array = []
var _audio_groups: Dictionary = {}

var _path_to_audio_definitions: String = "res://Resources/Configurations/audio_definitions.json"
const _POOL_SIZE: int = 25  # Define the initial size of the player pool

func _ready():
	_load_audio_definitions(_path_to_audio_definitions)
	_initialize_player_pool(_POOL_SIZE)

# Initialize a pool of AudioStreamPlayers
func _initialize_player_pool(size: int):
	for i in range(size):
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stop()  # Ensure player is in a stopped state
		_player_pool.append(player)

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

# Get an available AudioStreamPlayer from the pool or create a new one
func _get_audio_player() -> AudioStreamPlayer:
	if _player_pool.size() > 0:
		return _player_pool.pop_back()
	else:
		var player = AudioStreamPlayer.new()
		add_child(player)
		return player

# Return an AudioStreamPlayer to the pool
func _release_audio_player(player: AudioStreamPlayer):
	player.stop()
	player.stream = null  # Clear the stream to avoid memory leaks
	if not _player_pool.has(player):
		_player_pool.append(player)

# Play sound by audio_name
func _setup_audio_stream_player(audio_name: String, player: AudioStreamPlayer) -> AudioStreamPlayer:
	var audio_def: AudioDefinition = _get_audio_definition(audio_name)
	if audio_def:
		player.stream = audio_def.get_stream()
		player.bus = audio_def.bus
		return player
	push_error("Audio not found: %s" % audio_name)
	return null

# Handle player finishing and return it to the pool
func _on_player_finished(player: AudioStreamPlayer, should_loop: bool = false):
	if should_loop:
		player.play()
	else:
		player.finished.disconnect(_on_player_finished)
		_release_audio_player(player)

# Get all sounds by group
func _get_sounds_by_group(group_name: String) -> Array:
	return _audio_definitions.values().filter(func(audio_def): return audio_def.group == group_name)

# Play the next sound in the group
func _play_next_in_group(audio_player: AudioStreamPlayer, audio_group: AudioGroup, group_name: String):
	if audio_group.current_playlist.is_empty():
		if audio_group.repeat:
			audio_group.reset_playlist()
			if audio_group.should_be_random:
				audio_group.current_playlist.shuffle()
		else:
			audio_player.finished.disconnect(_on_group_finished)
			_release_audio_player(audio_player)
			return

	var selected_sound: AudioDefinition = audio_group.current_playlist.pop_front()
	_setup_audio_stream_player(selected_sound.name, audio_player)
	audio_player.finished.connect(_on_group_finished.bind(audio_player, audio_group, group_name))
	audio_player.play()

# Handle when a sound finishes playing
func _on_group_finished(audio_player: AudioStreamPlayer, audio_group: AudioGroup, group_name: String):
	audio_player.finished.disconnect(_on_group_finished)

	if audio_group.current_playlist.size() > 0 or audio_group.repeat:
		_play_next_in_group(audio_player, audio_group, group_name)
	else:
		_release_audio_player(audio_player)

# Set bus volume
func set_bus_volume(bus_name: String, volume: float):
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	else:
		push_error("Bus not found: %s" % bus_name)

# Stop and free a sound
func stop_sound(player: AudioStreamPlayer):
	if player:
		player.stop()
		_release_audio_player(player)

func stop_all_sounds():
	for child in get_children():
		if child is AudioStreamPlayer:
			stop_sound(child)

func play_single_sound(audio_name: String, should_loop: bool = false) -> AudioStreamPlayer:
	var player: AudioStreamPlayer = _setup_audio_stream_player(audio_name, _get_audio_player())
	player.finished.connect(_on_player_finished.bind(player, should_loop))
	player.play()
	return player

# Play a group of sounds with options for looping, randomizing, and playing the whole group
func play_group(group_name: String, should_loop: bool = false, play_whole_group: bool = false, should_randomize: bool = false) -> AudioStreamPlayer:
	var sounds: Array = _get_sounds_by_group(group_name)
	if sounds.is_empty():
		push_error("No sounds found for group: %s" % group_name)
		return null

	# Create or update the AudioGroup
	var audio_group: AudioGroup = AudioGroup.new(sounds, play_whole_group, should_randomize, should_loop)
	_audio_groups[group_name] = audio_group

	# Use a single AudioStreamPlayer for the group
	var audio_player: AudioStreamPlayer = _get_audio_player()
	
	# Shuffle playlist if randomize is enabled
	if should_randomize:
		audio_group.current_playlist.shuffle()
	
	# Start playback
	_play_next_in_group(audio_player, audio_group, group_name)
	return audio_player

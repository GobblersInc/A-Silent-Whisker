extends Node

var audio_definitions: Dictionary = {}
var player_pool: Array = []

var path_to_audio_definitions: String = "res://Resources/Configurations/audio_definitions.json"
const POOL_SIZE: int = 10  # Define the initial size of the player pool

func _ready():
	load_audio_definitions(path_to_audio_definitions)
	initialize_player_pool(POOL_SIZE)

# Initialize a pool of AudioStreamPlayers
func initialize_player_pool(size: int):
	for i in range(size):
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stop()  # Ensure player is in a stopped state
		player_pool.append(player)

# Load definitions from JSON
func load_audio_definitions(file_path: String):
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json: JSON = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			var data: Dictionary = json.data
			for name in data["audio_files"]:
				var details: Dictionary = data["audio_files"][name]
				var audio_def: AudioDefinition = AudioDefinition.new(details["bus"], details["group"], details["path"])
				audio_definitions[name] = audio_def
		else:
			push_error("Failed to parse JSON: %s" % parse_result.error_string)
	else:
		push_error("Failed to load audio definitions from file: %s" % file_path)

# Get or load sound using AudioDefinition
func get_audio_definition(name: String) -> AudioDefinition:
	return audio_definitions.get(name, null)

# Get an available AudioStreamPlayer from the pool or create a new one
func get_audio_player() -> AudioStreamPlayer:
	if player_pool.size() > 0:
		return player_pool.pop_back()
	else:
		var player = AudioStreamPlayer.new()
		add_child(player)
		return player

# Return an AudioStreamPlayer to the pool
func release_audio_player(player: AudioStreamPlayer):
	player.stop()
	player.stream = null  # Clear the stream to avoid memory leaks
	if not player_pool.has(player):
		player_pool.append(player)

# Play sound by name
func play_sound(name: String) -> AudioStreamPlayer:
	var audio_def: AudioDefinition = get_audio_definition(name)
	if audio_def:
		var player: AudioStreamPlayer = get_audio_player()
		player.stream = audio_def.get_stream()
		player.bus = audio_def.bus
		player.finished.connect(_on_player_finished)
		player.play()
		return player
	push_error("Audio not found: %s" % name)
	return null

# Handle player finishing and return it to the pool
func _on_player_finished(player: AudioStreamPlayer):
	player.finished.disconnect(_on_player_finished)
	release_audio_player(player)

# Stop and free a sound
func stop_sound(player: AudioStreamPlayer):
	if player:
		player.stop()
		release_audio_player(player)

# Set bus volume
func set_bus_volume(bus_name: String, volume: float):
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	else:
		push_error("Bus not found: %s" % bus_name)

# Example of a convenient function to stop all sounds
func stop_all_sounds():
	for child in get_children():
		if child is AudioStreamPlayer:
			stop_sound(child)

extends Node


func _ready():
	randomize()
	setup_audio_players()

# Audio data
var audio_definitions = {
	"TestMusic": {"bus": "Music", "group": "TestGroup1"}
	#"TestSFX": {"bus": "SFX", "group": "TestGroup1"},
	#"TestWeather": {"bus": "Weather", "group": "TestGroup1"}
}

# Preload audio files; can be altered/disabled if it causes performance degradation.
var preload_audio = {
	"TestMusic": preload("res://Assets/Audio/Music/TestMusic.ogg")
	#"TestSFX": preload("res://Assets/Audio/SFX/TestAudioSFX.wav"),
	#"TestWeather": preload("res://Assets/Audio/Weather/TestAudioWeather.ogg")
}

# Dictionary to store audio players
var audio_players = {}

# Create and configure each AudioStreamPlayer
func setup_audio_players():
	for audio_key in audio_definitions.keys():
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = preload_audio[audio_key]
		audio_player.bus = audio_definitions[audio_key]["bus"]
		add_child(audio_player)
		audio_players[audio_key] = audio_player

# Start playing a specific audio
func play_audio(audio_key):
	if audio_key in audio_players:
		audio_players[audio_key].play()

# Stop specific audio or all audio if no key is provided
func stop_audio(audio_key: String = ""):
	if audio_key == "":
		# Stop all audio players
		for player in audio_players.values():
			player.stop()
	elif audio_key in audio_players:
		# Stop the specific audio
		audio_players[audio_key].stop()

# Adjust the volume on a specific bus if needed
func set_bus_volume(bus_name, volume_db):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), volume_db)

# Returns a list of audio keys that belong to a given group
func get_sounds_by_group(group_name: String) -> Array:
	var sounds_in_group = []
	for audio_key in audio_definitions.keys():
		if audio_definitions[audio_key]["group"] == group_name:
			sounds_in_group.append(audio_key)
	return sounds_in_group

# Plays a random sound from a specified group
func play_random_sound_from_group(group_name: String):
	var sounds_in_group = get_sounds_by_group(group_name)
	if sounds_in_group.size() > 0:
		# Pick a random sound key from the list
		var random_index = randi() % sounds_in_group.size()
		var random_sound_key = sounds_in_group[random_index]
		# Play the sound
		play_audio(random_sound_key)
	else:
		print("The group does not exist. This is a dev message.")

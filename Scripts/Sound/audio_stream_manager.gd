extends Node
class_name AudioStreamManager

signal _finished_signal()

var audio_player: AudioStreamPlayer = null

func _init(audio_player_input: AudioStreamPlayer):
	self.audio_player = audio_player_input
	
func setup_audio_player(bus: String):
	if audio_player != null:
		audio_player.bus = bus
		audio_player.finished.connect(_emit_finished_signal)

func assign_stream(audio_definition: AudioDefinition):
	audio_player.stream = audio_definition.get_stream()

func play_audio_player():
	audio_player.play()

func dispose_audio_player():
	audio_player.stop()
	audio_player.stream = null
	audio_player.finished.disconnect(_emit_finished_signal)
	AudioPlayerPool.release_player(audio_player)

func _emit_finished_signal():
	_finished_signal.emit()

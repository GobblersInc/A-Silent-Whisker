extends Node
class_name PlayerPool

var _player_pool: Array[AudioStreamPlayer] = []
var pool_size: int = 25

func _ready():
	initialize_pool()

func initialize_pool():
	for i in range(pool_size):
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stop()
		_player_pool.append(player)

func get_player() -> AudioStreamPlayer:
	return _player_pool.pop_back() if _player_pool.size() > 0 else AudioStreamPlayer.new()

func release_player(player: AudioStreamPlayer):
	if _player_pool.size() < pool_size:
		_player_pool.append(player)
	else:
		player.queue_free()

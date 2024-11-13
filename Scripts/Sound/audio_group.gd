extends RefCounted
class_name AudioGroup

var group_name: String
var playlist: Playlist
var audio_stream_manager: AudioStreamManager

func _init(group_name_input: String, audio_stream_manager_input: AudioStreamManager, playlist_input: Playlist):
	self.group_name = group_name_input
	self.audio_stream_manager = audio_stream_manager_input
	self.playlist = playlist_input
	audio_stream_manager._finished_signal.connect(audio_player_finished)

func play():
	if playlist.original_playlist.size() > 0:
		audio_stream_manager.setup_audio_player(playlist.original_playlist[0].bus)
	
	_play_next_in_group()

func _play_next_in_group():
	if playlist.current_playlist.size() > 0:
		audio_stream_manager.assign_stream(playlist.current_playlist.pop_front())
		audio_stream_manager.play_audio_player()
	else:
		if playlist.repeat:
			playlist._reset_playlist()
			_play_next_in_group()
		else: 
			audio_stream_manager.dispose_audio_player()
			
func audio_player_finished():
	if playlist.should_play_all:
		_play_next_in_group()
	else:
		audio_stream_manager.dispose_audio_player()

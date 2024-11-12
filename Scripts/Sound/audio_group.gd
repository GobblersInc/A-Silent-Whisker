extends RefCounted
class_name AudioGroup

var original_playlist: Array
var current_playlist: Array
var should_play_all: bool
var should_be_random: bool
var repeat: bool

func _init(original_playlist_input: Array, should_play_all_input: bool, should_be_random_input: bool, repeat_input: bool):
	self.original_playlist = original_playlist_input
	self.current_playlist = original_playlist_input.duplicate()
	self.should_play_all = should_play_all_input
	self.should_be_random = should_be_random_input
	self.repeat = repeat_input

# Reset the playlist if needed
func reset_playlist():
	current_playlist = original_playlist.duplicate()

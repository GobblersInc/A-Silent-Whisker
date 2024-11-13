extends Node

class_name Playlist

var original_playlist: Array
var current_playlist: Array
var should_play_all: bool
var should_be_random: bool
var repeat: bool

func _init(original_playlist_input: Array, should_play_all_input: bool, should_be_random_input: bool, repeat_input: bool):
	self.original_playlist = original_playlist_input
	self.should_play_all = should_play_all_input
	self.should_be_random = should_be_random_input
	self.repeat = repeat_input
	_reset_playlist()

# Reset the playlist if needed
func _reset_playlist():
	current_playlist = original_playlist.duplicate()
	if should_be_random:
		current_playlist.shuffle()

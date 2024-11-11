extends RefCounted
class_name AudioGroup

var original_playlist: Array
var current_playlist: Array
var should_play_all: bool
var randomize: bool
var repeat: bool

func _init(original_playlist: Array, should_play_all: bool, randomize: bool, repeat: bool):
	self.original_playlist = original_playlist
	self.current_playlist = original_playlist.duplicate()
	self.should_play_all = should_play_all
	self.randomize = randomize
	self.repeat = repeat

# Reset the playlist if needed
func reset_playlist():
	current_playlist = original_playlist.duplicate()

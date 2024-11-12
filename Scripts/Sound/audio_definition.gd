extends RefCounted

class_name AudioDefinition

var name: String
var bus: String
var group: String
var path: String
var stream: AudioStream = null

func _init(name_input: String, bus_input: String, group_input: String, path_input: String):
	self.name = name_input
	self.bus = bus_input
	self.group = group_input
	self.path = path_input

func load_stream():
	if stream == null:
		stream = load(path)

func get_stream() -> AudioStream:
	if stream == null:
		load_stream()
	return stream

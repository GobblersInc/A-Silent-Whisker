extends RefCounted

class_name AudioDefinition

var name: String
var bus: String
var group: String
var path: String
var stream: AudioStream = null

func _init(name: String, bus: String, group: String, path: String):
	self.name = name
	self.bus = bus
	self.group = group
	self.path = path

func load_stream():
	if stream == null:
		stream = load(path)

func get_stream() -> AudioStream:
	if stream == null:
		load_stream()
	return stream

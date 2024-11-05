extends RefCounted

class_name AudioDefinition

var bus: String
var group: String
var path: String
var stream: AudioStream = null

func _init(bus: String, group: String, path: String):
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

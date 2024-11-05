extends Object

class_name AudioInstantier

var audio_definitions = {}
var preload_audio = {}

func register_audio(name: String, bus: String, group: String, path: String):
	audio_definitions[name] = AudioDefinition.new(bus, group)
	preload_audio[name] = preload(path)

func get_audio_definition(name: String):
	return audio_definitions.get(name)

func get_preloaded_audio(name: String):
	return preload_audio.get(name)
	

extends Object

class_name Busses

const SFX : String = "SFX"
const MUSIC : String = "Music"
const WEATHER : String = "Weather"
const MASTER : String = "Master"

func set_bus_volume(bus_name: String, volume: float):
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	else:
		push_error("Bus not found: %s" % bus_name)

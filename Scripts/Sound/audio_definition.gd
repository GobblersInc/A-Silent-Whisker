extends Object

class_name AudioDefinition

var bus: String
var group: int

# Constructor to initialize bus and group
func _init(bus: String = "", group: int = 0):
	self.bus = bus
	self.group = group

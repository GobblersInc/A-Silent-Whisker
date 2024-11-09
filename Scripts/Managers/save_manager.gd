extends Node

@onready var _Player = $Player

func _ready():
	pass # Replace with function body.

func save_game():
	# Need try catch to make sure there are no repeating save names
	var new_name = "{randomid}".format({"randomid": str(randi_range(0, 1000))})
	var nodes = _Player.get_property_list()
	var new_path = "thisisatestpath"
	
	var new_save = Save.new(new_name, new_path, nodes)
	
	print("Game is being saved!")

func load_game():
	print("Loading previous game!")

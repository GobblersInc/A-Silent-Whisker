extends Node

@onready var _Player = $Player

func _ready():
	pass # Replace with function body.

func save_game(save_name: String):
	# Need try catch to make sure there are no repeating save names
	# var nodes = _Player.get_property_list()
	# var tree_nodes = get_tree().get_nodes_in_group("Persist")
	var new_path = "res://User/Nodes/"
	var player_x = _Player.postion.x
	var player_y = _Player.postion.y
	
	print("Player position is: {nx}, {ny}".format({"nx": player_x, "ny": player_y}))
	
	var player_data = {
		"x": player_x,
		"y": player_y,
	}
	
	var new_save = Save.new(save_name, new_path, player_data)
	new_save.save_to_file()
	
	print("Game has been saved!")

func load_game(load_name: String):
	var temp_object = Save.new(load_name)
	var player_data = temp_object.load_from_file()
	if player_data == OK:
		_Player.position.x = player_data["x"]
		_Player.position.y = player_data["y"]
		print("Loaded previous game!")
	else:
		print("Failed to load previous game!")
	
	

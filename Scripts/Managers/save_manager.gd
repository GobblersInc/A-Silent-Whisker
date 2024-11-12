extends Node

func _ready():
	pass

func save_game(save_name: String, player_node: CharacterBody2D):
	# Need try catch to make sure there are no repeating save names
	# var nodes = _Player.get_property_list()
	# var tree_nodes = get_tree().get_nodes_in_group("Persist")
	
	var new_path = "res://User/Nodes/"
	
	if !(is_instance_valid(player_node)):
		push_error("Node is not valid: %s" % player_node)
	else:
		var player_position = player_node.global_position
		
		print("Player position is: {nx}".format({"nx": player_position}))
		
		var new_save = Save.new(save_name, new_path, player_position)
		new_save.save_to_file()

func load_game(load_name: String, player_node: CharacterBody2D):
	var temp_object = Save.new(load_name)
	var player_data = temp_object.load_from_file()
	player_node.global_position = player_data
	
	

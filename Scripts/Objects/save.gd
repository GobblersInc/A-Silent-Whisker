extends Node

# Add save abilities for character position so you can revert back to their previous place in the scene or location
# Serializing dictionary to file
# Binary Serialization (Appraoch to take)
# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

# Use PackedScenes to store nodes and their properties
# Use Resources to save player specific data (Score, lives, etc, etc), settings, etc

class_name Save

var save_name: String
var path: String
var nodes: Object

func _init(init_name: String, init_path: String, init_nodes: Object):
	self.save_name = init_name
	self.path = init_path
	self.nodes = init_nodes

func get_save_nodes() -> Object:
	return self.nodes
	
func set_save_nodes(new_nodes: Object) -> void:
	self.nodes = new_nodes
	
func get_save_path() -> String:
	return self.path
	
func set_save_path(new_path: String) -> void:
	self.path = new_path
	
func get_save_name() -> String:
	return self.save_name
	
func set_save_name(new_name: String) -> void:
	self.save_name = new_name
	
func _to_string() -> String:
	return "{sname}, {spath}, {snodes}".format({"sname": self.save_name, "spath": self.path, "snodes": self.nodes})

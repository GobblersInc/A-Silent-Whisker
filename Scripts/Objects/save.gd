extends Node

# Add save abilities for character position so you can revert back to their previous place in the scene or location
# Serializing dictionary to file
# Binary Serialization (Appraoch to take)
# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

# Use PackedScenes to store nodes and their properties
# Use Resources to save player specific data (Score, lives, etc, etc), settings, etc

# Save player position and current scene (All we need right now)
# Can add delivery saves later

# Transition parallax backgrounds (500 x 200)

class_name Save

var save_name: String
var complete_path: String
var path: String
var nodes: Variant

func _init(init_name: String = "default", init_path: String = "res://User/Nodes/", init_nodes: Variant = ""):
	self.save_name = init_name
	self.path = init_path
	self.nodes = init_nodes
	self.complete_path = self.path + "{save_name}.cfg".format({"save_name": self.save_name})
	
func save_to_file() -> void:
	var save_file = FileAccess.open(self.complete_path, FileAccess.WRITE)
	save_file.store_var(self.nodes, true)
	
	#var array_nodes: Array[Node] = self.nodes
	#
	#for node in self.nodes:
		#
		#if node.scene_file_path.is_empty():
			#print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			#continue
			#
		#if !node.has_method("save"):
			#print("persistent node '%s' is missing a save() function, skipped" % node.name)
			#continue
		#
		#var node_data = node.call("")

func load_from_file() -> Variant:
	if not FileAccess.file_exists(self.complete_path):
		push_error("Failed to load save file at path: %s" % self.complete_path)
		return
	else:
		var load_file = FileAccess.open(self.complete_path, FileAccess.READ)
		var return_data = load_file.get_var(true)
		return return_data
	
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
	return "{sname}, {spath}, {snodes}, {scomplete}".format({"sname": self.save_name, "spath": self.path, "snodes": self.nodes, "complete_path": self.complete_path,})

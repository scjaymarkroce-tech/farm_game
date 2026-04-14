class_name SaveLevelDataComponents
extends Node

var level_scene_name : String
var save_game_data_path : String = "user://game_data/" #im not so sure about this part
var save_file_name : String = "save_%s_game_data.tres"
var game_data_resource : SaveGameDataResource

func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name
	
func save_node_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	game_data_resource = SaveGameDataResource.new()
	
	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node._save_data()
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)
				
				
func save_game() -> void :
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)
	
	var level_save_file_name: String = save_file_name % level_scene_name
	
	save_node_data()
	
	var result : int = ResourceSaver.save(game_data_resource, save_game_data_path + level_save_file_name)
	print("Save Result: ", result)
	

func load_game() -> void: 
	var level_save_file_name : String = save_file_name % level_scene_name
	var save_game_path : String = save_game_data_path + level_save_file_name
	
	if !FileAccess.file_exists(save_game_path):
		print("No save file found.")
		return
		
	game_data_resource = ResourceLoader.load(save_game_path) as SaveGameDataResource
	
	if game_data_resource == null:
		print("Failed to load save data.")
		return
		
	var root_node : Window = get_tree().root
	
	for resource in game_data_resource.save_data_nodes:
		if resource is NodeDataResource:
			resource._load_data(root_node)
		

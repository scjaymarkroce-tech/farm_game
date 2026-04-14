class_name CropsCursorComponent
extends Node


@export var tilled_soil_tilemap_layer : TileMapLayer

var player : Player
var corn_plant_scene = preload("res://scenes/objects/corns/corn.tscn")
var tomato_plant_scene = preload("res://scenes/objects/tomatoes/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float
var global_cell_position: Vector2 # Add this to the top variables list


func _ready() -> void:
	await get_tree().process_frame
	player 	= get_tree().get_first_node_in_group("player")
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()
			


func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position) 		
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	
	# FIX: Convert local to global for distance check
	global_cell_position = tilled_soil_tilemap_layer.to_global(local_cell_position)
	distance = player.global_position.distance_to(global_cell_position)

func add_crop() -> void: 
	if distance < 60.0: # Keep this increased radius
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			var corn_instance = corn_plant_scene.instantiate() as Node2D
			# FIX: Spawn at global_cell_position instead of local_cell_position
			corn_instance.global_position = global_cell_position
			get_parent().find_child("CropFields").add_child(corn_instance)
			
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			var tomato_instance = tomato_plant_scene.instantiate() as Node2D
			# FIX: Spawn at global_cell_position instead of local_cell_position
			tomato_instance.global_position = global_cell_position
			get_parent().find_child("CropFields").add_child(tomato_instance)

func remove_crop() -> void:
	if distance < 60.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		
		for node: Node2D in crop_nodes:
			# FIX: Check against global_cell_position
			if node.global_position == global_cell_position:
				node.queue_free()
		
		
		
		
		
		
		

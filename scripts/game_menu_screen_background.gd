extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("set_scene_process_mode")


func set_scene_process_mode() -> void:
	process_mode = PROCESS_MODE_DISABLED

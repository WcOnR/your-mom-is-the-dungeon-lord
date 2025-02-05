class_name World extends Node2D


@export var preset : ProgressionPreset = null


func _ready() -> void:
	await get_tree().process_frame
	SceneLoaderSystem.start_game(self, preset)

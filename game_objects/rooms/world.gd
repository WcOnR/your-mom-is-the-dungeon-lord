class_name World extends Node2D


@export var preset : ProgressionPreset = null
@export var game_autoload : PackedScene = null


func _ready() -> void:
	await get_tree().process_frame
	SceneLoaderSystem.start_game(self, preset)


func load_game_autoload() -> void:
	var node := game_autoload.instantiate()
	add_child(node)

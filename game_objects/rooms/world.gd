class_name World extends Node2D


@export var preset : ProgressionPreset = null
@export var game_autoload : PackedScene = null
@export var final_scene : PackedScene = null


func _ready() -> void:
	await get_tree().process_frame
	SceneLoaderSystem.start_game(self, preset, final_scene)


func load_game_autoload() -> void:
	var node := game_autoload.instantiate()
	add_child(node)


func fade_in() -> void:
	var fade := %SceneFade
	var duration := 0.3
	fade.modulate = Color(Color.BLACK, 0.0)
	var tween := get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color(Color.BLACK, 1.0), duration)
	await get_tree().create_timer(duration).timeout


func fade_out() -> void:
	var fade := %SceneFade
	var duration := 0.3
	fade.modulate = Color(Color.BLACK, 1.0)
	await get_tree().create_timer(duration).timeout
	var tween := get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color(Color.BLACK, 0.0), duration)
	await get_tree().create_timer(duration).timeout

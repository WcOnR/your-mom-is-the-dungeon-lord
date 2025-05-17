class_name SceneLoader extends Node

var _world : Node2D
var _preset : ProgressionPreset = null
var _final_scene : PackedScene = null
var _room : Node2D = null

func start_game(world : Node2D, preset : ProgressionPreset, final_scene : PackedScene) -> void:
	_world = world
	_world.load_game_autoload()
	_final_scene = final_scene
	_preset = preset.duplicate()
	for r in _preset.rooms:
		r.on_room_reset()
	_load_next_room()


func unload_room() -> void:
	await _world.fade_in()
	if _room != null:
		if not _room.is_queued_for_deletion():
			_room.queue_free()
		_world.remove_child(_room)
		_room = null
	_load_next_room()


func load_win_scene() -> void:
	await _world.fade_in()
	if _room != null:
		if not _room.is_queued_for_deletion():
			_room.queue_free()
		_world.remove_child(_room)
		_room = null
	var scene := _final_scene.instantiate()
	_world.add_child(scene)
	await _world.fade_out()


func is_next_room() -> bool:
	return not _preset.rooms.is_empty()


func get_world() -> World:
	return _world


func _load_next_room() -> void:
	if _preset.rooms.is_empty():
		print("Unexpected path")
		get_tree().quit()
		return
	var room_preset := _preset.rooms.pop_front() as RoomPreset
	_room = room_preset.scene.instantiate()
	_world.add_child(_room)
	room_preset.on_room_init(_room)
	await _world.fade_out()
	

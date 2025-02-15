class_name SceneLoader extends Node

var _world : Node2D
var _preset : ProgressionPreset = null
var _room : Node2D = null

func start_game(world : Node2D, preset : ProgressionPreset) -> void:
	_world = world
	_world.load_game_autoload()
	_preset = preset.duplicate()
	for r in _preset.rooms:
		r.on_room_reset()
	_load_next_room()


func unload_room() -> void:
	if _room != null:
		if not _room.is_queued_for_deletion():
			_room.queue_free()
		_world.remove_child(_room)
		_room = null
	_load_next_room()


func is_next_room() -> bool:
	return not _preset.rooms.is_empty()


func _load_next_room() -> void:
	if _preset.rooms.is_empty():
		print("Unexpected path")
		get_tree().quit()
		return
	var room_preset := _preset.rooms.pop_front() as RoomPreset
	_room = room_preset.scene.instantiate()
	_world.add_child(_room)
	room_preset.on_room_init(_room)
	

class_name BattleRoomPreset extends RoomPreset

@export var pool : Array[BattlePreset] = []

var _pool : Array[BattlePreset] = []


func on_room_reset() -> void:
	_pool = pool.duplicate()


func on_room_init(_room : Node2D) -> void:
	var gm := _room.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var preset : BattlePreset = _pool.pop_at(randi_range(0, _pool.size() - 1))
	gm.start_battle(preset)

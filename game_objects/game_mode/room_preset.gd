class_name RoomPreset extends Resource

@export var scene : PackedScene


# Functions need to be override for specific room types 
func on_room_reset() -> void:
	pass

func on_room_init(_room : Node2D) -> void:
	pass

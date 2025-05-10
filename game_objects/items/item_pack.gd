class_name ItemPack extends RefCounted

var item_preset : ItemPreset = null
var count : int = 0

func _init(preset : ItemPreset) -> void:
	item_preset = preset


func get_price(level : int) -> int:
	return floori(item_preset.price * pow(2.0, level - 1.0))

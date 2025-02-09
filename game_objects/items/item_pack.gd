class_name ItemPack extends RefCounted

var item_preset : ItemPreset = null
var count : int = 0

func _init(preset : ItemPreset) -> void:
	item_preset = preset

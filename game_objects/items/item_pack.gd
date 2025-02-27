class_name ItemPack extends RefCounted

var item_preset : ItemPreset = null
var count : int = 0

func _init(preset : ItemPreset) -> void:
	item_preset = preset


func get_price() -> int:
	var percent : float = 0
	var shift : float = 1
	for i in count:
		percent += shift
		shift *= 0.9
	return floori(item_preset.price * percent)

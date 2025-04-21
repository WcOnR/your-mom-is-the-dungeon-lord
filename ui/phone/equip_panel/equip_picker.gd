class_name EquipPicker extends Button

var _pack : ItemPack = null


func set_equip(pack : ItemPack) -> void:
	%EquipViewer.set_equip(pack)
	_pack = pack


func get_item() -> ItemPreset:
	return _pack.item_preset if _pack else null


func set_selection(selected : bool) -> void:
	%Selected.visible = selected

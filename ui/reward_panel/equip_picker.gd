class_name EquipPicker extends Button

var item : ItemPreset = null

func set_equip(item_preset : ItemPreset) -> void:
	$ItemViewer.set_item(item_preset)
	item = item_preset

func set_selection(selected : bool) -> void:
	%Selected.visible = selected

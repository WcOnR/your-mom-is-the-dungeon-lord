class_name EquipPicker extends Button

var item : ItemPreset = null
var _hint : Hint = null


func set_equip(item_preset : ItemPreset) -> void:
	$ItemViewer.set_item(item_preset)
	item = item_preset
	if item:
		_hint = item.create_hint(self)
	else:
		_hint = null


func set_selection(selected : bool) -> void:
	%Selected.visible = selected


func get_hint_under_cursor(rect : Rect2) -> Hint:
	var self_rect := Rect2(global_position, size)
	if self_rect.intersects(rect):
		return _hint
	return null

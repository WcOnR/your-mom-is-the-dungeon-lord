class_name ItemPackViewer extends Control

var _hint : Hint = null

func set_pack(pack : ItemPack) -> void:
	$ItemViewer.set_item(pack.item_preset)
	$CountLabel.visible = false
	if pack.item_preset.type == ItemPreset.Type.CONSUMABL:
		$CountLabel.text = "x" + str(pack.count)
		$CountLabel.visible = true
		_hint = pack.item_preset.create_hint(self)
	if pack.item_preset.type == ItemPreset.Type.BOOSTER:
		_hint = pack.item_preset.create_hint(self)


func get_hint_under_cursor(rect : Rect2) -> Hint:
	var self_rect := Rect2(global_position, size)
	if self_rect.intersects(rect):
		return _hint
	return null

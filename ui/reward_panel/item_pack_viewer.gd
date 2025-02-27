class_name ItemPackViewer extends Control

var _hint : Hint = null

func set_pack(pack : ItemPack) -> void:
	$ItemViewer.set_item(pack.item_preset)
	$CountLabel.visible = false
	var pack_type := pack.item_preset.type
	if pack_type == ItemPreset.Type.CONSUMABL or pack_type == ItemPreset.Type.BOOSTER:
		$CountLabel.text = "x" + str(pack.count)
		$CountLabel.visible = true
	_hint = pack.item_preset.create_hint(self)


func set_gray_out() -> void:
	$CountLabel.visible = false
	$ItemViewer.set_gray_out()


func get_hint_under_cursor(rect : Rect2) -> Hint:
	var self_rect := Rect2(global_position, size)
	if self_rect.intersects(rect):
		return _hint
	return null

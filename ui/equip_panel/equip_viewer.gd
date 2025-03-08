class_name EquipViewer extends Control


var _pack : ItemPack = null
var _hint : Hint = null


func set_equip(pack : ItemPack, is_reward : bool = true) -> void:
	$ItemViewer.set_item(pack.item_preset if pack else null)
	_pack = pack
	_hint = null
	$Quality.visible = false
	if _pack and _pack.item_preset:
		var hint_text : String = ""
		if is_reward:
			hint_text = SettingsManager.settings.get_reward_equip_hint(_pack)
		else:
			hint_text = SettingsManager.settings.get_equip_hint(_pack)
			$Quality.modulate = SettingsManager.settings.get_pack_color(pack)
			$Quality.visible = true
		_hint = Hint.new(_pack.item_preset.item_name, hint_text, self)


func set_gray_out(gray_out : bool) -> void:
	$ItemViewer.modulate = Color.DIM_GRAY if gray_out else Color.WHITE


func get_hint_under_cursor(rect : Rect2) -> Hint:
	var self_rect := Rect2(global_position, size)
	if self_rect.intersects(rect):
		return _hint
	return null

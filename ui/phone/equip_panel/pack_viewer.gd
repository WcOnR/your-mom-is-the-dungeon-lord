class_name PackViewer extends Control


var _pack : ItemPack = null


func set_pack(pack : ItemPack, is_reward : bool = true) -> void:
	$ItemViewer.set_item(pack.item_preset if pack else null)
	_pack = pack
	$Quality.visible = false
	$CountLabel.visible = false
	var settings := SettingsManager.get_settings()
	if not (_pack and _pack.item_preset):
		return
	if _pack.item_preset.is_equip():
		if not is_reward:
			$Quality.modulate = settings.get_pack_color(_pack)
			$Quality.visible = true
	else:
		$CountLabel.text = "x" + str(_pack.count)
		$CountLabel.visible = true


func set_gray_out(gray_out : bool) -> void:
	$ItemViewer.modulate = Color.DIM_GRAY if gray_out else Color.WHITE
	$CountLabel.visible = _pack and not(gray_out or _pack.item_preset.is_equip())

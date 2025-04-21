class_name ItemPackViewer extends Control

var _pack : ItemPack = null
var _hint : Hint = null
var _is_equip : bool = false

func set_pack(pack : ItemPack) -> void:
	_pack = pack
	var pack_type := pack.item_preset.type
	_is_equip =  pack_type == ItemPreset.Type.EQUIP or pack_type == ItemPreset.Type.SUPER_EQUIP
	if _is_equip:
		$EquipViewer.visible = true
		$EquipViewer.set_equip(pack)
		_hint = $EquipViewer._hint
		$ItemViewer.visible = false
		$CountLabel.visible = false
	else:
		$ItemViewer.visible = true
		$ItemViewer.set_item(pack.item_preset)
		$CountLabel.text = "x" + str(pack.count)
		$CountLabel.visible = true
		_hint = pack.item_preset.create_hint(self)
		$EquipViewer.visible = false


func set_gray_out(grat_out : bool) -> void:
	$CountLabel.visible = not grat_out and not _is_equip
	$ItemViewer.set_gray_out(grat_out)
	$EquipViewer.set_gray_out(grat_out)

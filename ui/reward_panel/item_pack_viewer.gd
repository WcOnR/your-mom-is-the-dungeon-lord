class_name ItemPackViewer extends Control


func set_pack(pack : ItemPack) -> void:
	$ItemViewer.set_item(pack.item_preset)
	$CountLabel.visible = false
	if pack.item_preset.type == ItemPreset.Type.CONSUMABL:
		$CountLabel.text = "x" + str(pack.count)
		$CountLabel.visible = true
	

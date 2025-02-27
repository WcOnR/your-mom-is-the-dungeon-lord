class_name ConsumeItemInfo extends MarginContainer


func set_pack(pack : ItemPack) -> void:
	%Label.text = ": %d" % pack.count
	%Icon.texture = pack.item_preset.texture

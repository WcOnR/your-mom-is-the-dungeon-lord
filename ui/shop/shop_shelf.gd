class_name ShopShelf extends MarginContainer


@onready var viewer_scene : PackedScene = preload("res://ui/shop/shop_item.tscn")
@onready var shelf_container := %ShelfContainer


func set_shelf_view(item_packs : Array[ItemPack]) -> void:
	for pack in item_packs:
		var viewer := viewer_scene.instantiate() as ShopItem
		viewer.set_item(pack)
		shelf_container.add_child(viewer)


func get_hint_under_cursor(rect : Rect2) -> Hint:
	for node in shelf_container.get_children():
		var hint : Hint = node.get_hint_under_cursor(rect)
		if hint:
			return hint
	return null

class_name ShopShelf extends MarginContainer


@onready var viewer_scene : PackedScene = preload("res://ui/shop/shop_item.tscn")
@onready var shelf_container := %ShelfContainer


func set_shelf_view(items : Array[ShopItemData]) -> void:
	for item in items:
		var viewer := viewer_scene.instantiate() as ShopItem
		viewer.set_shop_item(item)
		shelf_container.add_child(viewer)

class_name ShopShelf extends MarginContainer


@onready var viewer_scene : PackedScene = preload("res://ui/shop/shop_item.tscn")
@onready var shelf_container := %ShelfContainer


func set_shelf_view(items : Array[ShopItemData]) -> void:
	var player := get_tree().get_first_node_in_group("Player") as Player
	var level := player.shop_level
	
	for item in items:
		var viewer := viewer_scene.instantiate() as ShopItem
		viewer.set_shop_item(item, str(item.pack.get_price(level)))
		shelf_container.add_child(viewer)

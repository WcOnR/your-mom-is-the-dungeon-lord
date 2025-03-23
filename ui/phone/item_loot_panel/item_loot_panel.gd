class_name ItemLootPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/reward_panel/item_pack_viewer.tscn")
@onready var item_container := %ItemContainer


func set_reward_view(item_packs : Array[ItemPack]) -> void:
	for pack in item_packs:
		var viewer := viewer_scene.instantiate() as ItemPackViewer
		viewer.set_pack(pack)
		item_container.add_child(viewer)


func get_hint_under_cursor(rect : Rect2) -> Hint:
	for node in item_container.get_children():
		var hint : Hint = node.get_hint_under_cursor(rect)
		if hint:
			return hint
	return null

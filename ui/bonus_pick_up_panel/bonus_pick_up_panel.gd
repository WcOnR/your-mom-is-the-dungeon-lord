class_name BonusPickUpPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/reward_panel/item_pack_viewer.tscn")
@onready var reward_container := %RewardsContainer


signal collected()


func set_reward_view(item_packs : Array[ItemPack]) -> void:
	for pack in item_packs:
		var viewer := viewer_scene.instantiate() as ItemPackViewer
		viewer.set_pack(pack)
		reward_container.add_child(viewer)


func get_hint_under_cursor(rect : Rect2) -> Hint:
	for node in reward_container.get_children():
		var hint : Hint = node.get_hint_under_cursor(rect)
		if hint:
			return hint
	return null


func _on_button_pressed() -> void:
	collected.emit()

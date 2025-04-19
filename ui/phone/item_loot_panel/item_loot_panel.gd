class_name ItemLootPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/reward_panel/item_pack_viewer.tscn")
@onready var viewer : ItemPackViewer = %ItemPackViewer
@onready var item_hint : EquipHint = %EquipHint
@onready var buy_btn : Button = %BuyButton


signal buy_btn_pressed


func set_reward_view(pack : ItemPack) -> void:
	viewer.set_pack(pack)
	if pack.item_preset.type == ItemPreset.Type.EQUIP:
		item_hint.set_equip(pack, true)
	else:
		item_hint.set_item(pack.item_preset)


func show_buy_btn(_show : bool) -> void:
	buy_btn.visible = _show


func _on_buy_btn_pressed() -> void:
	buy_btn_pressed.emit()

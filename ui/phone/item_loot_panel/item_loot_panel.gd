class_name ItemLootPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/phone/item_loot_panel/item_pack_viewer.tscn")
@onready var viewer : ItemPackViewer = %ItemPackViewer
@onready var item_hint : EquipHint = %EquipHint
@onready var buy_btn : Button = %BuyButton
@onready var equip_btn : Button = %EquipButton
@onready var bottom_panel : Control = %BottomPanel
@onready var coin_panel : CoinPanel = %CoinPanel

var _phone : Phone = null


signal buy_btn_pressed


func _ready() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	coin_panel.update_amount(player.inventory_comp)


func set_reward_view(pack : ItemPack) -> void:
	viewer.set_pack(pack)
	if pack.item_preset.type == ItemPreset.Type.EQUIP:
		item_hint.set_equip(pack, true)
	else:
		item_hint.set_item(pack.item_preset)


func show_buy_btn(_show : bool) -> void:
	buy_btn.visible = _show
	equip_btn.visible = _show
	bottom_panel.visible = _show


func _on_buy_btn_pressed() -> void:
	buy_btn_pressed.emit()


func _on_equip_button_pressed() -> void:
	if _phone == null:
		_phone = get_tree().get_first_node_in_group("Phone") as Phone
	_phone.add_to_panel_stack(_phone.get_equipment_panel())

class_name EquipLootPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/phone/equip_panel/equip_picker.tscn")
@onready var item_container := %ItemContainer

signal selection_changed

var _selected_equip : ItemPreset = null
var _pickers : Array[EquipPicker] = []
var _phone : Phone = null


func _ready() -> void:
	%EquipHint.clear()


func set_reward_view(equip : Array[ItemPreset]) -> void:
	for item in equip:
		var picker := viewer_scene.instantiate() as EquipPicker
		_pickers.append(picker)
		var pack := ItemPack.new(item)
		pack.count = 1
		picker.set_equip(pack)
		picker.pressed.connect(_on_equip_pick.bind(picker))
		item_container.add_child(picker)
	_on_equip_pick(_pickers[floori(_pickers.size() / 2.0)])


func get_selected_equip() -> ItemPreset:
	return _selected_equip


func _on_equip_pick(picker : EquipPicker) -> void:
	if _selected_equip == picker.get_item():
		return
	for p in _pickers:
		p.set_selection(false)
	picker.set_selection(true)
	_selected_equip = picker.get_item()
	%EquipHint.set_equip(ItemPack.new(_selected_equip), true)
	selection_changed.emit()


func _on_equip_button_pressed() -> void:
	if _phone == null:
		_phone = get_tree().get_first_node_in_group("Phone") as Phone
	_phone.add_to_panel_stack(_phone.get_equipment_panel())

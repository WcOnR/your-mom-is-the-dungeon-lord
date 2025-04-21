class_name EquipLootPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/phone/equip_panel/equip_picker.tscn")
@onready var item_container := %ItemContainer

signal selection_changed

var _selected_equip : ItemPreset = null
var _pickers : Array[EquipPicker] = []


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

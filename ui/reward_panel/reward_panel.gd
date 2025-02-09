class_name RewardPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/reward_panel/item_pack_viewer.tscn")
@onready var equip_scene : PackedScene = preload("res://ui/reward_panel/equip_picker.tscn")


signal collected(equip_choice : ItemPreset)

var _equip : Array[ItemPreset] = []
var _is_choice := false
var _selected_equip : ItemPreset = null
var _pickers : Array[EquipPicker] = []


func set_reward_view(item_packs : Array[ItemPack]) -> void:
	for pack in item_packs:
		var viewer := viewer_scene.instantiate() as ItemPackViewer
		viewer.set_pack(pack)
		%RewardsContainer.add_child(viewer)


func set_equip_choice(equip : Array[ItemPreset]) -> void:
	_equip = equip


func _setup_equip() -> void:
	_is_choice = true
	%CollectButton.disabled = true
	%CallToActionLabel.text = "CHOOSE ONE"
	var ch := %RewardsContainer.get_children()
	while not ch.is_empty():
		ch[0].queue_free()
		%RewardsContainer.remove_child(ch[0])
		ch = %RewardsContainer.get_children()
	for item in _equip:
		var picker := equip_scene.instantiate() as EquipPicker
		_pickers.append(picker)
		picker.set_equip(item)
		picker.pressed.connect(_on_equip_pick.bind(picker))
		%RewardsContainer.add_child(picker)


func _on_equip_pick(picker : EquipPicker) -> void:
	for p in _pickers:
		p.set_selection(false)
	picker.set_selection(true)
	_selected_equip = picker.item
	%CollectButton.disabled = false


func _on_button_pressed() -> void:
	if _equip.is_empty() or _is_choice:
		collected.emit(_selected_equip)
	_setup_equip()

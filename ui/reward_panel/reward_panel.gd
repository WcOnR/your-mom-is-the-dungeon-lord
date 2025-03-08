class_name RewardPanel extends Control


@onready var viewer_scene : PackedScene = preload("res://ui/reward_panel/item_pack_viewer.tscn")
@onready var equip_scene : PackedScene = preload("res://ui/reward_panel/equip_picker.tscn")
@onready var reward_container := %RewardsContainer


signal collected(equip_choice : ItemPreset)

var _equip : Array[ItemPreset] = []
var _is_choice := false
var _selected_equip : ItemPreset = null
var _pickers : Array[EquipPicker] = []


func set_reward_view(item_packs : Array[ItemPack]) -> void:
	for pack in item_packs:
		var viewer := viewer_scene.instantiate() as ItemPackViewer
		viewer.set_pack(pack)
		reward_container.add_child(viewer)


func set_equip_choice(equip : Array[ItemPreset]) -> void:
	_equip = equip


func get_hint_under_cursor(rect : Rect2) -> Hint:
	for node in reward_container.get_children():
		var hint : Hint = node.get_hint_under_cursor(rect)
		if hint:
			return hint
	return null


func _setup_equip() -> void:
	_is_choice = true
	%CollectButton.disabled = true
	%CallToActionLabel.text = "CHOOSE ONE"
	var ch := reward_container.get_children()
	while not ch.is_empty():
		ch[0].queue_free()
		reward_container.remove_child(ch[0])
		ch = reward_container.get_children()
	_set_equip_pickers()


func _set_equip_pickers() -> void:
	for item in _equip:
		var picker := equip_scene.instantiate() as EquipPicker
		_pickers.append(picker)
		var pack := ItemPack.new(item)
		pack.count = 1
		picker.set_equip(pack)
		picker.pressed.connect(_on_equip_pick.bind(picker))
		reward_container.add_child(picker)


func _on_equip_pick(picker : EquipPicker) -> void:
	for p in _pickers:
		p.set_selection(false)
	picker.set_selection(true)
	_selected_equip = picker.get_item()
	%CollectButton.disabled = false


func _on_button_pressed() -> void:
	if _equip.is_empty() or _is_choice:
		collected.emit(_selected_equip)
	_setup_equip()

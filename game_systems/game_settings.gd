class_name GameSettings extends Resource

@export var currency : ItemPreset = null
@export var equip_data : Array[EquipMetadata] = []
@export var consumabl_presets : Array[ItemPreset] = []
@export var booster_presets : Array[ItemPreset] = []

@export var consumabl_prob : float = 1.0
@export var extra_consumabl_prob : float = 0.5
@export var max_consumabl_reward : int = 3
@export var consumabl_prob_weight : Array[int] = []

@export var equip_level_colors : Array[Color] = []
@export var max_equip_level : int = 3
@export var equip_count : int = 3

@export var max_items_in_shop : int = 4
@export var min_equip_count_in_shop : int = 1

@export var line_colors : Array[Color] = []

@export var sounds : CommonSounds = null


func get_equip_hint(pack : ItemPack) -> String:
	for data in equip_data:
		if data.item_preset_a == pack.item_preset:
			return data.item_description_a[pack.count - 1]
		if data.item_preset_b == pack.item_preset:
			return data.item_description_b[pack.count - 1]
		if data.super_item_preset == pack.item_preset:
			return data.super_item_preset.item_description
	return ""


func get_reward_equip_hint(pack : ItemPack) -> String:
	for data in equip_data:
		if data.item_preset_a == pack.item_preset:
			return data.get_full_item_description_a()
		if data.item_preset_b == pack.item_preset:
			return data.get_full_item_description_b()
		if data.super_item_preset == pack.item_preset:
			return data.super_item_preset.item_description
	return ""


func get_equip_metadata(item_preset : ItemPreset) -> EquipMetadata:
	for data in equip_data:
		if item_preset in data.get_items() or data.super_item_preset == item_preset:
			return data
	return null


func get_pack_color(pack : ItemPack) -> Color:
	if pack.item_preset.type == ItemPreset.Type.EQUIP:
		return equip_level_colors[pack.count - 1]
	elif pack.item_preset.type == ItemPreset.Type.SUPER_EQUIP:
		return equip_level_colors[max_equip_level]
	return Color.FUCHSIA

class_name GameSettings extends Resource

@export var currency : ItemPreset = null
@export var equip_presets : Array[ItemPreset] = []
@export var consumabl_presets : Array[ItemPreset] = []
@export var booster_presets : Array[ItemPreset] = []

@export var consumabl_prob : float = 1.0
@export var extra_consumabl_prob : float = 0.5
@export var max_consumabl_reward : int = 3
@export var consumabl_prob_weight : Array[int] = []

@export var equip_count : int = 3

@export var max_items_in_shop : int = 4
@export var min_equip_count_in_shop : int = 1

@export var line_colors : Array[Color] = []

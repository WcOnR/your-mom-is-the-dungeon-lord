class_name EquipMetadata extends Resource

@export var item_preset_a : ItemPreset = null
@export var item_description_a : Array[String] = []
@export var item_preset_b : ItemPreset = null
@export var item_description_b : Array[String] = []

@export var super_item_preset : ItemPreset = null


const LEVEL_STR : String = "%sLevel %d:%s %s\n\n"


func get_items() -> Array[ItemPreset]:
	return [item_preset_a, item_preset_b]


func get_full_item_description_a() -> String:
	return get_full_item_description(item_description_a)


func get_full_item_description_b() -> String:
	return get_full_item_description(item_description_b)


func get_full_item_description(item_description : Array[String]) -> String:
	var restult : String = ""
	var settings := SettingsManager.get_settings()
	
	for i in item_description.size():
		var prefix := "[b][color=%s]" % [settings.equip_level_colors[i].to_html(false)]
		restult += LEVEL_STR % [prefix, i + 1, "[/color][/b]", item_description[i]]
	restult = restult.left(restult.length() - 1)
	return restult

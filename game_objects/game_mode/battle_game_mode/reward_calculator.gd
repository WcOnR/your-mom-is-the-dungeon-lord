class_name RewardCalculator extends Node


func get_statistics(battle : BattlePreset) -> Array[StatisticsInfo]:
	var map : Dictionary = {}
	var result : Array[StatisticsInfo]
	if battle:
		for enemy in battle.line1:
			var has : int = map[enemy] if enemy in map else 0
			map[enemy] = has + 1
		for enemy in battle.line2:
			var has : int = map[enemy] if enemy in map else 0
			map[enemy] = has + 1
		for enemy in battle.line3:
			var has : int = map[enemy] if enemy in map else 0
			map[enemy] = has + 1
		for enemy in map.keys():
			var info := StatisticsInfo.new()
			info.name = "Killed %s" % enemy.name
			info.count = map[enemy]
			info.score = enemy.reward * info.count
			result.append(info)
	return result


func get_rewards() -> Array[ItemPack]:
	var reward : Array[ItemPack] = []
	var add_consumabl := SettingsManager.settings.consumabl_prob >= randf()
	if add_consumabl:
		reward.append(_get_consumabl(1)[0])
	return reward


func get_equip_choice(inventory : InventoryComp) -> Array[ItemPreset]:
	var result : Array[ItemPreset] = []
	for i in SettingsManager.settings.equip_count:
		var equip := _get_equip(inventory, result)
		if equip:
			result.append(equip)
	return result


func get_shop_items(inventory : InventoryComp) -> Array[ItemPack]:
	var settings := SettingsManager.settings
	var equip_count := randi_range(settings.min_equip_count_in_shop, settings.equip_count)
	var result : Array[ItemPack] = []
	var items : Array[ItemPreset] = []
	for i in equip_count:
		var equip := _get_equip(inventory, items)
		if equip:
			items.append(equip)
	var consum := _get_consumabl(settings.max_items_in_shop - items.size())
	result.append_array(consum)
	for i in items:
		var pack := ItemPack.new(i)
		pack.count = 1
		result.append(pack)
	result.shuffle()
	return result


func _get_consumabl(count : int) -> Array[ItemPack]:
	var result : Array[ItemPack] = []
	var settings := SettingsManager.settings
	var weights := settings.consumabl_prob_weight.duplicate()
	for c in count:
		var preset := _pick_random_with_weight(settings.consumabl_presets, weights)
		for i in settings.consumabl_presets.size():
			if settings.consumabl_presets[i] == preset:
				weights[i] = max(weights[i] - 1, 0)
		var pack := ItemPack.new(preset)
		pack.count = 1
		for i in settings.max_consumabl_reward:
			if settings.extra_consumabl_prob >= randf():
				pack.count += 1
		result.append(pack)
	return result


func _get_equip(inventory : InventoryComp, ignore : Array[ItemPreset]) -> ItemPreset:
	var settings := SettingsManager.settings
	var fav_items : Array[ItemPreset] = []
	for slot in inventory.get_slots():
		if slot != null:
			fav_items.append(slot.item_preset)
	var preset_pool : Array[ItemPreset] = []
	for data in settings.equip_data:
		for item in data.get_items():
			if inventory.is_fit_in_slots(item):
				preset_pool.append(item)
	var pool := preset_pool.duplicate()
	for i in ignore:
		pool.erase(i)
	if pool.is_empty():
		for item in preset_pool:
			if item.type == ItemPreset.Type.SUPER_EQUIP:
				pool.append(item)
	preset_pool = pool
	
	var weight : Array[int] = []
	for equip in preset_pool:
		var w := 1
		if equip in fav_items or equip.type == ItemPreset.Type.SUPER_EQUIP:
			w += 5
		weight.append(w)
	return _pick_random_with_weight(preset_pool, weight)


func _pick_random_with_weight(items : Array[ItemPreset], weight : Array[int]) -> ItemPreset:
	if items.is_empty() or weight.size() != items.size():
		return null
	var sum_weight := 0
	for w in weight: 
		sum_weight += w
	var target := randi_range(0, sum_weight - 1)
	var i := 0
	var sum_it := 0
	while i < items.size():
		sum_it += weight[i]
		if target < sum_it:
			return items[i]
		i += 1
	return null

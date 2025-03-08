class_name RewardCalculator extends Node


func get_rewards(battle : BattlePreset) -> Array[ItemPack]:
	var reward : Array[ItemPack] = []
	var add_consumabl := SettingsManager.settings.consumabl_prob >= randf()
	if add_consumabl:
		reward.append(_get_consumabl(1)[0])
	
	if battle:
		var count := 0
		for enemy in battle.line1:
			count += enemy.reward
		for enemy in battle.line2:
			count += enemy.reward
		for enemy in battle.line3:
			count += enemy.reward
		var pack := ItemPack.new(SettingsManager.settings.currency)
		pack.count = count
		reward.append(pack)
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


func _get_equip_presets() -> Array[ItemPreset]:
	var equip_presets : Array[ItemPreset] = []
	for data in SettingsManager.settings.equip_data:
		equip_presets.append(data.item_preset_a)
		equip_presets.append(data.item_preset_b)
	return equip_presets


func _get_equip(inventory : InventoryComp, ignore : Array[ItemPreset]) -> ItemPreset:
	var settings := SettingsManager.settings
	var fav_items : Array[ItemPreset] = []
	var maxed_items : Array[ItemPreset] = []
	var slots := inventory.get_slots()
	for s in slots:
		if s == null:
			break
		if s.count == settings.max_equip_level:
			maxed_items.append(s.item_preset)
		fav_items.append(s.item_preset)
	## Get pool
	var preset_pool := _get_equip_presets()
	## Filter pool
	if fav_items.size() == settings.equip_count:
		preset_pool = fav_items.duplicate()
	for maxed in maxed_items:
		preset_pool.erase(maxed)
	## Add super equip to pool if possible
	var metadatas : Array[EquipMetadata] = []
	for maxed in maxed_items:
		var data := settings.get_equip_metadata(maxed)
		if data in metadatas:
			preset_pool.append(data.super_item_preset)
		metadatas.append(data)
	## Filter super equip
	for item in fav_items:
		if item.type == ItemPreset.Type.SUPER_EQUIP:
			for data in settings.equip_data:
				if data.super_item_preset == item:
					preset_pool.erase(data.item_preset_a)
					preset_pool.erase(data.item_preset_b)
					preset_pool.erase(data.super_item_preset)
					break
	## Setup weights
	var weight : Array[int] = []
	for equip in preset_pool:
		var w := 1
		if equip in fav_items:
			w += 5
		if equip in ignore and equip.type == ItemPreset.Type.EQUIP:
			w = 0
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

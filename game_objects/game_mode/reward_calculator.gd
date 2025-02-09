class_name RewardCalculator extends RefCounted


func get_rewards(battle : BattlePreset) -> Array[ItemPack]:
	var reward : Array[ItemPack] = []
	var settings := SettingsManager.settings
	var add_consumabl := settings.consumabl_prob >= randf()
	if add_consumabl:
		var c := _pick_random_with_weight(settings.consumabl_presets, settings.consumabl_prob_weight)
		var pack := ItemPack.new(c)
		pack.count = 1
		for i in settings.max_consumabl_reward:
			if settings.extra_consumabl_prob >= randf():
				pack.count += 1
		reward.append(pack)
	
	if battle:
		var count := 0
		for enemy in battle.line1:
			count += enemy.reward
		for enemy in battle.line2:
			count += enemy.reward
		for enemy in battle.line3:
			count += enemy.reward
		var pack := ItemPack.new(settings.currency)
		pack.count = count
		reward.append(pack)
	return reward


func get_equip_choice(inventory : InventoryComp) -> Array[ItemPreset]:
	var result : Array[ItemPreset] = []
	for i in 3:
		result.append(_get_equip(inventory, result))
	return result


func _get_equip(inventory : InventoryComp, ignore : Array[ItemPreset]) -> ItemPreset:
	var settings := SettingsManager.settings
	var fav_items : Array[ItemPreset] = []
	var slots := inventory.get_slots()
	for s in slots:
		if s == null:
			break
		fav_items.append(s.item_preset)
	var weight : Array[int] = []
	for equip in settings.equip_presets:
		var w := 1
		if equip in fav_items:
			w += 5
		elif fav_items.size() == 3:
			w = 0
		if equip in ignore:
			w = 0
		weight.append(w)
	return _pick_random_with_weight(settings.equip_presets, weight)


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

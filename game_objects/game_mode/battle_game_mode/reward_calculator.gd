class_name RewardCalculator extends Node


func get_statistics(battle : BattlePreset, events : Dictionary) -> Array:
	var map : Dictionary = {}
	var result : Array[StatisticsInfo]
	var sum := 0
	if battle:
		var lines := battle.get_lines()
		for line in lines:
			for enemy in line:
				var has : int = map[enemy] if enemy in map else 0
				map[enemy] = has + 1
		for enemy in map.keys():
			var info := StatisticsInfo.new()
			info.name = "%s was killed" % enemy.name
			info.count = map[enemy]
			info.score = enemy.reward * info.count
			sum += info.score
			result.append(info)
		
		var bonus_price := {BattleGameMode.IN_ONE_HIT : ["Decisive Thrust", 100],
		BattleGameMode.IN_SELF_HIT : ["I didn\'t do that", 500],
		BattleGameMode.HEALCAP : ["Overheal", 300],
		BattleGameMode.ATTACKCAP : ["Powerful Strike", 300],
		BattleGameMode.SHIELDCAP : ["Invincible", 300],
		BattleGameMode.SKULLCAP : ["I did survive this!", 750]}
		for key in bonus_price.keys():
			if key in events and events[key] > 0:
				var info := StatisticsInfo.new()
				info.name = "\"%s\"" % bonus_price[key][0]
				info.count = events[key]
				info.score = bonus_price[key][1] * info.count
				sum += info.score
				result.append(info)
		
		var bonus_mult := {BattleGameMode.FLAWLESS_VICTORY : ["Untouchable", 2],
		BattleGameMode.IN_ONE_TURN : ["They Didn\'t Saw It Coming", 2]}
		for key in bonus_mult.keys():
			if key in events:
				var info := StatisticsInfo.new()
				info.name = "\"%s\"" % bonus_mult[key][0]
				info.is_multiplayer = true
				info.count = bonus_mult[key][1]
				sum = sum * info.count
				result.append(info)
	return [sum, result]


func get_rewards() -> Array[ItemPack]:
	var reward : Array[ItemPack] = []
	var add_consumabl := SettingsManager.get_settings().consumabl_prob >= randf()
	if add_consumabl:
		reward.append(_get_consumabl(1)[0])
	return reward


func get_equip_choice(inventory : InventoryComp) -> Array[ItemPreset]:
	var result : Array[ItemPreset] = []
	for i in SettingsManager.get_settings().equip_count:
		var equip := _get_equip(inventory, result)
		if equip:
			result.append(equip)
	return result


func get_shop_items(inventory : InventoryComp) -> Array[ItemPack]:
	var settings := SettingsManager.get_settings()
	var equip_count := randi_range(settings.min_equip_count_in_shop, settings.equip_count)
	var result : Array[ItemPack] = []
	var items : Array[ItemPreset] = []
	for i in equip_count:
		var equip := _get_equip(inventory, [])
		if equip:
			items.append(equip)
	var consum := _get_consumabl(settings.max_items_in_shop - items.size(), true)
	result.append_array(consum)
	for i in items:
		var pack := ItemPack.new(i)
		pack.count = 1
		result.append(pack)
	result.shuffle()
	return result


func _get_consumabl(count : int, one_only : bool = false) -> Array[ItemPack]:
	var result : Array[ItemPack] = []
	var settings := SettingsManager.get_settings()
	var weights := settings.consumabl_prob_weight.duplicate()
	for c in count:
		var preset := _pick_random_with_weight(settings.consumabl_presets, weights)
		for i in settings.consumabl_presets.size():
			if settings.consumabl_presets[i] == preset:
				weights[i] = max(weights[i] - 1, 0)
		var pack := ItemPack.new(preset)
		pack.count = 1
		if not one_only:
			for i in settings.max_consumabl_reward:
				if settings.extra_consumabl_prob >= randf():
					pack.count += 1
		result.append(pack)
	return result


func _get_equip(inventory : InventoryComp, ignore : Array[ItemPreset]) -> ItemPreset:
	var settings := SettingsManager.get_settings()
	var fav_items : Array[ItemPreset] = []
	var super_metadata : Array[EquipMetadata] = []
	for slot in inventory.get_slots():
		if slot != null:
			fav_items.append(slot.item_preset)
			if slot.item_preset.type == ItemPreset.Type.SUPER_EQUIP:
				super_metadata.append(settings.get_equip_metadata(slot.item_preset))
	var preset_pool : Array[ItemPreset] = []
	for data in settings.equip_data:
		if not data in super_metadata:
			for item in data.get_items():
				if inventory.is_fit_in_slots(item):
					preset_pool.append(item)
	for i in ignore:
		preset_pool.erase(i)
	
	var weight : Array[int] = []
	for equip in preset_pool:
		var w := 1
		if equip in fav_items:
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

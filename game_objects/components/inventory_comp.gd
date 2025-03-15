class_name InventoryComp extends Node

var _slots : Array[ItemPack] = [null, null, null]
var _consumabls : Array[ItemPack] = []
var _boosters : Array[ItemPack] = []

signal items_changed

const ON_PICK_UP : StringName = "on_pick_up"


func _ready() -> void:
	for slot in _slots:
		slot = ItemPack.new(null)
	var consumabl_presets := SettingsManager.settings.consumabl_presets
	for preset in consumabl_presets:
		_consumabls.append(ItemPack.new(preset))
	_consumabls.append(ItemPack.new(SettingsManager.settings.currency))
	var booster_presets := SettingsManager.settings.booster_presets
	for preset in booster_presets:
		_boosters.append(ItemPack.new(preset))


func add_pack(pack : ItemPack) -> void:
	match pack.item_preset.type:
		ItemPreset.Type.CONSUMABL:
			_add_count(_consumabls, pack)
		ItemPreset.Type.BOOSTER:
			for i in pack.count:
				pack.item_preset.action.run(ON_PICK_UP, [get_parent()])
			_add_count(_boosters, pack)
		ItemPreset.Type.EQUIP:
			_add_to_slot(pack)
		ItemPreset.Type.SUPER_EQUIP:
			_add_super_to_slot(pack)
	items_changed.emit()


func add_item(item : ItemPreset) -> void:
	var pack := ItemPack.new(item)
	pack.count = 1
	add_pack(pack)


func consume_item(item : ItemPreset) -> void:
	if item.type != ItemPreset.Type.CONSUMABL:
		return
	var pack := _get_pack(item)
	if pack.count > 0:
		pack.count -= 1
	items_changed.emit()


func spend_money(amount : int) -> void:
	var pack := get_currency_pack()
	pack.count = pack.count - amount
	items_changed.emit()


func get_slots() -> Array[ItemPack]:
	return _slots


func can_buy(pack : ItemPack) -> bool:
	var currency_pack := get_currency_pack()
	var enough_currency := pack.get_price() <= currency_pack.count
	var type := pack.item_preset.type
	var is_equipment := type == ItemPreset.Type.EQUIP or type ==ItemPreset.Type.SUPER_EQUIP
	var can_be_pickup := not is_equipment or is_fit_in_slots(pack.item_preset)
	return enough_currency and can_be_pickup


func get_currency_pack() -> ItemPack:
	for pack in _consumabls:
		if pack.item_preset == SettingsManager.settings.currency:
			return pack
	return null


func get_pack(item : ItemPreset) -> ItemPack:
	var holder := _get_pack_holder(item.type)
	for pack in holder:
		if pack.item_preset == item:
			return pack
	return null


func _add_super_to_slot(pack : ItemPack) -> void:
	var settings := SettingsManager.settings
	var metadata : EquipMetadata = null
	for data in settings.equip_data:
		if data.super_item_preset == pack.item_preset:
			metadata = data
			break
	for i in _slots.size():
		var preset := _slots[i].item_preset if _slots[i] != null else null
		if preset == metadata.item_preset_a or preset == metadata.item_preset_b:
			_slots[i] = null
			if pack:
				_slots[i] = pack
				pack = null
	var was_null := false
	for i in _slots.size():
		if _slots[i] == null:
			was_null = true
		elif was_null:
			if _slots[i] != null:
				_slots[i - 1] = _slots[i]
				_slots[i] = null
			else:
				was_null = false


func is_fit_in_slots(item : ItemPreset) -> bool:
	var max_equip_level := SettingsManager.settings.max_equip_level
	var items : Array[ItemPreset] = []
	var maxed_items : Array[ItemPreset] = []
	for slot in _slots:
		if slot != null:
			items.append(slot.item_preset)
			if slot.count == max_equip_level:
				maxed_items.append(slot.item_preset)
	if item.type == ItemPreset.Type.EQUIP:
		if not (item in items):
			return _slots.size() != items.size()
		return not (item in maxed_items)
	if item in items:
		return false
	var metadatas : Array[EquipMetadata] = []
	for maxed in maxed_items:
		var data := SettingsManager.settings.get_equip_metadata(maxed)
		if data in metadatas and data.super_item_preset == item:
			return true
		metadatas.append(data)
	return false
	


func _add_to_slot(pack : ItemPack) -> void:
	var i := 0
	while i < _slots.size():
		if _slots[i] == null:
			_slots[i] = ItemPack.new(pack.item_preset)
			break
		elif _slots[i].item_preset == pack.item_preset:
			break
		i += 1
	_add_count(_slots, pack)


func _add_count(packs : Array[ItemPack], pack : ItemPack) -> void:
	for p in packs:
		if pack.item_preset == p.item_preset:
			p.count += pack.count
			break


func _get_pack(item : ItemPreset) -> ItemPack:
	var pack_holder := _get_pack_holder(item.type)
	for pack in pack_holder:
		if item == pack.item_preset:
			return pack
	return null


func _get_pack_holder(type : ItemPreset.Type) -> Array[ItemPack]:
	match type:
		ItemPreset.Type.CONSUMABL:
			return _consumabls
		ItemPreset.Type.BOOSTER:
			return _boosters
		ItemPreset.Type.EQUIP, ItemPreset.Type.SUPER_EQUIP:
			return _slots
	return []

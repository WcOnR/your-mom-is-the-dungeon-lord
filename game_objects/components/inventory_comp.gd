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
	var has_slot := false
	for s in _slots:
		if s == null or s.item_preset == pack.item_preset:
			has_slot = true
			break
	return enough_currency and has_slot


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


func _add_to_slot(pack : ItemPack) -> void:
	var i := 0
	while i < _slots.size():
		if _slots[i] == null:
			_slots[i] = ItemPack.new(pack.item_preset)
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

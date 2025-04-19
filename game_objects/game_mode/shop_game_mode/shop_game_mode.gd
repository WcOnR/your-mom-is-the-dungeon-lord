class_name ShopGameMod extends Node

var _player : Player = null
var _shop_items : Array[ShopItemData] = []
var _selected_item : ShopItemData = null
var _phone : Phone = null


func set_phone(phone : Phone) -> void:
	_phone = phone
	var btn := _phone.get_home_btn()
	btn.pressed.connect(finish_room)
	_player = get_tree().get_first_node_in_group("Player") as Player
	_player.inventory_comp.items_changed.connect(_update_shop_view)
	_phone.panel_changed.connect(_on_panel_changed)
	var item_loot_panel := _phone.get_item_loot_panel()
	item_loot_panel.buy_btn_pressed.connect(_on_buy)
	_update_shop_view()


func get_shop_items() -> Array[ShopItemData]:
	if _shop_items.is_empty():
		_player = get_tree().get_first_node_in_group("Player") as Player
		var packs : Array[ItemPack] = $RewardCalculator.get_shop_items(_player.inventory_comp)
		for pack in packs:
			var data := ShopItemData.new(pack)
			data.selection_changed.connect(_on_shop_item_selected.bind(data))
			_shop_items.append(data)
	return _shop_items


func finish_room() -> void:
	SceneLoaderSystem.unload_room()


func _on_shop_item_selected(data : ShopItemData) -> void:
	if not data.is_selected:
		return
	_selected_item = data
	for item in _shop_items:
		if item != data:
			item.select(false)
	var item_loot_panel := _phone.get_item_loot_panel()
	item_loot_panel.set_reward_view(data.pack)
	item_loot_panel.show_buy_btn(true)
	_phone.add_to_panel_stack(item_loot_panel)


func _on_buy() -> void:
	_player.inventory_comp.spend_money(_selected_item.pack.get_price())
	_selected_item.is_sold_out = true
	_player.inventory_comp.add_pack(_selected_item.pack)
	_phone.pop_top_panel()


func _on_panel_changed() -> void:
	var panel := _phone.get_top_panel()
	for item in _shop_items:
		item.enable_selection(not panel or panel is ItemLootPanel)
	if panel and panel is ItemLootPanel:
		_selected_item.select(true)
	elif _selected_item != null:
		_selected_item.select(false)


func _update_shop_view() -> void:
	var btn := _phone.get_home_btn()
	btn.set_state(HomeBtn.State.ACTIVE)
	for item in _shop_items:
		if item.can_buy(_player.inventory_comp):
			btn.set_state(HomeBtn.State.NORMAL)

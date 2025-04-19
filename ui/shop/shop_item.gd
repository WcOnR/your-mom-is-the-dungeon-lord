class_name ShopItem extends MarginContainer

@onready var item_pack_viewer := %ItemPackViewer
@onready var price_lbl := %PriceLabel
@onready var select_btn := $SelectButton
@onready var selected_back := %SelectedBack

var _inventory : InventoryComp = null
var _shop_item : ShopItemData = null


func _ready() -> void:
	select_btn.pressed.connect(_on_select)
	var player = get_tree().get_first_node_in_group("Player") as Player
	_inventory = player.inventory_comp
	_inventory.items_changed.connect(_update_view)
	_update_view()


func set_shop_item(shop_item : ShopItemData) -> void:
	_shop_item = shop_item
	_shop_item.selection_changed.connect(_update_view)
	%ItemPackViewer.set_pack(_shop_item.pack)
	%PriceLabel.text = str(_shop_item.pack.get_price())


func _update_view() -> void:
	var can_buy := _shop_item.can_buy(_inventory)
	%SoldOutPanel.visible = _shop_item.is_sold_out
	select_btn.disabled = not can_buy
	selected_back.visible = _shop_item.is_selected
	%CoinPanel.visible = can_buy
	%ItemPackViewer.set_gray_out(not can_buy)


func _on_select() -> void:
	_shop_item.select(true)

class_name ShopItem extends MarginContainer

@onready var item_pack_viewer := %ItemPackViewer
@onready var price_lbl := %PriceLabel
@onready var select_btn := $SelectButton

var _inventory : InventoryComp = null
var _shop_item : ShopItemData = null


func _ready() -> void:
	select_btn.pressed.connect(_on_select)
	var player = get_tree().get_first_node_in_group("Player") as Player
	_inventory = player.inventory_comp
	_inventory.items_changed.connect(_update_view)
	_update_view()


func set_shop_item(shop_item : ShopItemData, price : String) -> void:
	_shop_item = shop_item
	_shop_item.selection_changed.connect(_update_view)
	%ItemPackViewer.set_pack(_shop_item.pack)
	%PriceLabel.text = price


func _update_view() -> void:
	var can_buy := _shop_item.can_buy(_inventory)
	%SoldOutPanel.visible = _shop_item.is_sold_out
	select_btn.disabled = not can_buy
	%CoinPanel.visible = !_shop_item.is_sold_out
	%ItemPackViewer.set_gray_out(not can_buy)
	%CoinPanel.modulate = Color.WHITE if can_buy else Color.DIM_GRAY


func _on_select() -> void:
	_shop_item.select(true)

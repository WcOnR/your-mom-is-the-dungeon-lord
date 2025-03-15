class_name ShopItem extends MarginContainer

@onready var item_pack_viewer := %ItemPackViewer
@onready var price_lbl := %PriceLabel
@onready var buy_btn := %BuyButton

var _inventory : InventoryComp = null
var _pack : ItemPack = null
var _is_sold_out : bool = false


func _ready() -> void:
	buy_btn.pressed.connect(_on_buy)
	var player = get_tree().get_first_node_in_group("Player") as Player
	_inventory = player.inventory_comp
	_inventory.items_changed.connect(_update_view)
	_update_view()


func set_item(pack : ItemPack) -> void:
	_pack = pack
	%ItemPackViewer.set_pack(pack)
	%PriceLabel.text = str(pack.get_price())


func get_hint_under_cursor(rect : Rect2) -> Hint:
	return item_pack_viewer.get_hint_under_cursor(rect)


func _update_view() -> void:
	var can_buy := not _is_sold_out and _inventory.can_buy(_pack)
	%SoldOutPanel.visible = _is_sold_out
	buy_btn.visible = can_buy
	%CoinPanel.visible = can_buy
	%ItemPackViewer.set_gray_out(not can_buy)


func _on_buy() -> void:
	_inventory.spend_money(_pack.get_price())
	_inventory.add_pack(_pack)
	_is_sold_out = true
	_update_view()
	

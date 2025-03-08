class_name ShopItem extends MarginContainer

@onready var item_pack_viewer := %ItemPackViewer
@onready var price_lbl := %PriceLabel
@onready var buy_btn := %BuyButton

var _inventory : InventoryComp = null
var _pack : ItemPack = null


func _ready() -> void:
	buy_btn.pressed.connect(_on_buy)
	var player = get_tree().get_first_node_in_group("Player") as Player
	_inventory = player.inventory_comp
	_inventory.items_changed.connect(_update_availability)
	_update_availability()


func set_item(pack : ItemPack) -> void:
	_pack = pack
	%ItemPackViewer.set_pack(pack)
	%PriceLabel.text = str(pack.get_price())


func get_hint_under_cursor(rect : Rect2) -> Hint:
	return item_pack_viewer.get_hint_under_cursor(rect)


func _update_availability() -> void:
	_hide_buy_btn(not _inventory.can_buy(_pack))


func _hide_buy_btn(hide_btn : bool) -> void:
	%ItemPackViewer.set_gray_out(hide_btn)
	%BuyButton.visible = not hide_btn


func _update_view() -> void:
	%SoldOutPanel.visible = true
	%BuyButton.visible = false
	%CoinPanel.visible = false
	%ItemPackViewer.set_gray_out(true)


func _on_buy() -> void:
	_inventory.spend_money(_pack.get_price())
	_inventory.add_pack(_pack)
	_update_view()
	

class_name ShopItemData extends RefCounted

var pack : ItemPack = null
var is_sold_out : bool = false
var is_selected : bool = false
var can_be_selected : bool = true


signal selection_changed


func _init(_pack : ItemPack) -> void:
	pack = _pack


func can_buy(inventory : InventoryComp) -> bool:
	return not is_sold_out and inventory.can_buy(pack)


func enable_selection(_enable : bool) -> void:
	can_be_selected = _enable


func select(_selected : bool) -> void:
	if not can_be_selected:
		return
	if _selected != is_selected:
		is_selected = _selected
		selection_changed.emit()

class_name CoinPanel extends MarginContainer

var _inventory : InventoryComp = null

func show_amount(count : int) -> void:
	%Label.text = str(count)


func update_amount(inventory : InventoryComp) -> void:
	_inventory = inventory
	inventory.items_changed.connect(_on_items_update)
	_on_items_update()


func _on_items_update() -> void:
	var pack := _inventory.get_currency_pack()
	show_amount(pack.count)
	

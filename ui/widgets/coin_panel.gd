class_name CoinPanel extends MarginContainer

var _inventory : InventoryComp = null


func update_amount(inventory : InventoryComp) -> void:
	_inventory = inventory
	inventory.items_changed.connect(_on_items_update)
	_on_items_update()

func _on_items_update() -> void:
	var pack := _inventory.get_pack(SettingsManager.settings.currency)
	%Label.text = str(pack.count)
	

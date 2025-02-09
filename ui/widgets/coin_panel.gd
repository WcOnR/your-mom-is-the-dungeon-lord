class_name CoinPanel extends MarginContainer


func update_amount(inventory : InventoryComp) -> void:
	var pack := inventory.get_pack(SettingsManager.settings.currency)
	%Label.text = str(pack.count)

class_name EquipPanel extends Control

@onready var item_viewers : Array[EquipViewer] = [%Slot1, %Slot2, %Slot3]

var _inventory : InventoryComp = null


func update_view(inventory : InventoryComp) -> void:
	_inventory = inventory
	inventory.items_changed.connect(_on_items_update)
	_on_items_update()
	


func _on_items_update() -> void:
	var slots := _inventory.get_slots()
	for i in slots.size():
		item_viewers[i].set_equip(slots[i], false)


func get_hint_under_cursor(rect : Rect2) -> Hint:
	for slot in item_viewers:
		var hint := slot.get_hint_under_cursor(rect)
		if hint:
			return hint
	return null

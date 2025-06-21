class_name EquipPanel extends Control

@onready var item_viewers : Array[PackViewer] = [%Slot1, %Slot2, %Slot3]
@onready var item_hint : Array[EquipHint] = [%EquipHint1, %EquipHint2, %EquipHint3]

var _inventory : InventoryComp = null


func update_view(inventory : InventoryComp) -> void:
	_inventory = inventory
	inventory.items_changed.connect(_on_items_update)
	_on_items_update()


func _on_items_update() -> void:
	var slots := _inventory.get_slots()
	for i in slots.size():
		item_viewers[i].set_pack(slots[i], false)
		item_hint[i].set_equip(slots[i], false)

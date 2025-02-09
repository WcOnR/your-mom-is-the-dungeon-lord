class_name EquipViewer extends Control

@onready var item_viewers : Array[ItemViewer] = [%Slot1, %Slot2, %Slot3]


func update_view(inventory : InventoryComp) -> void:
	var slots := inventory.get_slots()
	var i := 0
	for s in slots:
		if s:
			item_viewers[i].set_item(s.item_preset)
			i += i

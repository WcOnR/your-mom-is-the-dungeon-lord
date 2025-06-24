class_name EquipPanel extends Control

@onready var item_viewers : Array[PackViewer] = [%Slot1, %Slot2, %Slot3]
@onready var item_hint : Array[EquipHint] = [%EquipHint1, %EquipHint2, %EquipHint3]
@onready var slot_container : Array[Container] = [%SlotContainer, %SlotContainer2, %SlotContainer3]

var _inventory : InventoryComp = null


func _ready() -> void:
	for hint in item_hint:
		hint.info_toggled.connect(_on_toggle.bind(hint))


func update_view(inventory : InventoryComp) -> void:
	_inventory = inventory
	inventory.items_changed.connect(_on_items_update)
	_on_items_update()


func _on_items_update() -> void:
	var slots := _inventory.get_slots()
	for i in slots.size():
		item_viewers[i].set_pack(slots[i], false)
		item_hint[i].set_equip(slots[i], false)


func _on_toggle(to_show : bool, hint : EquipHint) -> void:
	for slot in slot_container:
		slot.visible = not to_show or hint.get_parent() == slot
	

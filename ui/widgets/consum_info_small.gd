class_name ConsumInfoSmall extends HBoxContainer

@onready var info : Array[ConsumeItemInfo] = [$ConsumItemInfo, $ConsumItemInfo2, $ConsumItemInfo3]

var _inventory : InventoryComp = null

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player") as Player
	_inventory = player.inventory_comp
	_inventory.items_changed.connect(_on_items_update)
	_on_items_update()


func _on_items_update() -> void:
	var items := SettingsManager.settings.consumabl_presets
	for i in items.size(): 
		info[i].set_pack(_inventory.get_pack(items[i]))

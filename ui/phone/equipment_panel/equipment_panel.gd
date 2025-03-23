class_name EquipmentPanel extends MarginContainer

@onready var panel : EquipPanel = $VBoxContainer/EquipPanel
@onready var coin_panel : CoinPanel = %CoinPanel

func _ready() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	panel.update_view(player.inventory_comp)
	coin_panel.update_amount(player.inventory_comp)

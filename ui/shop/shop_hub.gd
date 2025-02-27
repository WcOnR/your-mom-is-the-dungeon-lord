class_name ShopHub extends Control

@export var game_mode : NodePath
@export var shady : NodePath

@onready var shelf_container := %ShopShelf
@onready var equip_viewer := %EquipViewer
@onready var coin_panel := %CoinPanel

var _game_mode : ShopGameMod = null


func _ready() -> void:
	_game_mode = get_node(game_mode) as ShopGameMod
	var player = get_tree().get_first_node_in_group("Player") as Player
	equip_viewer.update_view(player.inventory_comp)
	coin_panel.update_amount(player.inventory_comp)
	shelf_container.set_shelf_view(_game_mode.get_shop_items())
	%ExitButton.pressed.connect(_on_exit)


func _on_exit() -> void:
	_game_mode.finish_room()

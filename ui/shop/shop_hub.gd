class_name ShopHub extends Control

@export var game_mode : NodePath
@export var shady : NodePath

@onready var shelf_container := %ShopShelf

var _game_mode : ShopGameMod = null


func _ready() -> void:
	_game_mode = get_node(game_mode) as ShopGameMod
	shelf_container.set_shelf_view(_game_mode.get_shop_items())

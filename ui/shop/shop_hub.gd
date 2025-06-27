class_name ShopHub extends Control

@export var game_mode : NodePath
@export var labels : Array[NodePath]
@export var hand : NodePath

@onready var shelf_container := %ShopShelf

const DEACTIVE_COLOR := Color.DIM_GRAY
const NORMAL_COLOR := Color(0.85, 0.85, 0.85)
const HI_COLOR := Color.WHITE


var _game_mode : ShopGameMod = null
var _inventory : InventoryComp = null

func _ready() -> void:
	_game_mode = get_node(game_mode) as ShopGameMod
	var shop_items = _game_mode.get_shop_items()
	for i in shop_items.size():
		shop_items[i].selection_changed.connect(_on_selection_changed.bind(i))
	shelf_container.set_shelf_view(shop_items)
	var player = get_tree().get_first_node_in_group("Player") as Player
	_inventory = player.inventory_comp
	_inventory.items_changed.connect(_update_view)
	_update_view()


func _on_selection_changed(i : int) -> void:
	_update_item(i)


func _update_view() -> void:
	var shop_items = _game_mode.get_shop_items()
	for i in shop_items.size():
		_update_item(i)


func _update_item(i : int) -> void:
	var shop_item := _game_mode.get_shop_items()[i]
	var label := get_node(labels[i]) as Sprite2D
	var is_avalible := not shop_item.is_sold_out and shop_item.can_buy(_inventory)
	if shop_item.is_selected:
		var _hand := get_node(hand) as Node2D
		var tween := create_tween()
		tween.tween_property(_hand, "rotation", _hand.rotation + _hand.get_angle_to(label.global_position), 0.1)
		label.modulate = HI_COLOR
		var selection_sound := SettingsManager.get_settings().sounds.selection
		SoundSystem.play_sound(selection_sound)
	else:
		label.modulate = NORMAL_COLOR if is_avalible else DEACTIVE_COLOR

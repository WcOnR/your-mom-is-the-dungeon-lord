class_name ConsumableItemHolder extends Control

@export var item_preset : ItemPreset = null
@onready var viewer : ItemViewer = $ItemViewer
@onready var label : Label = $ItemViewer/CountLabel

var _field : Field = null
var _pack : ItemPack = null
var _hint : Hint = null
var _inventory_comp : InventoryComp = null

signal begin_hold


func _ready() -> void:
	_field = get_tree().get_first_node_in_group("Field")
	viewer.set_item(item_preset)
	viewer.set_modular_color(Color.DIM_GRAY)
	_pack = ItemPack.new(item_preset)
	_hint = item_preset.create_hint(self)
	var player := get_tree().get_first_node_in_group("Player") as Player
	_inventory_comp = player.inventory_comp
	_inventory_comp.items_changed.connect(_on_item_updated)
	_on_item_updated()


func _on_item_updated() -> void:
	if _inventory_comp == null:
		return
	_pack.count = _inventory_comp.get_pack(item_preset).count
	label.text = str(_pack.count)
	if _pack.count > 0:
		viewer.set_modular_color(Color.WHITE)
	else:
		viewer.set_modular_color(Color.DIM_GRAY)


func get_hint_under_cursor(rect : Rect2) -> Hint:
	var self_rect := Rect2(global_position, size)
	if self_rect.intersects(rect):
		return _hint
	return null


func _on_button_button_down() -> void:
	if _pack.count > 0:
		var follower := MouseFollower.create(item_preset.texture, item_preset, self.get_parent().get_parent())
		_field.start_drag(follower)
		begin_hold.emit()

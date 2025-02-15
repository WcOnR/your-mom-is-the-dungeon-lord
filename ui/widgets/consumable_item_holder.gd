class_name ConsumableItemHolder extends Control

@export var item_preset : ItemPreset = null
@onready var viewer : ItemViewer = $ItemViewer
@onready var label : Label = $ItemViewer/CountLabel

var _field : Field = null
var _pack : ItemPack = null
var _hint : Hint = null


func _ready() -> void:
	viewer.set_item(item_preset)
	viewer.set_modular_color(Color.DIM_GRAY)


func set_field(field : Field) -> void:
	_field = field


func set_pack(pack : ItemPack) -> void:
	_pack = pack
	if pack and pack.item_preset:
		var preset := pack.item_preset
		_hint = preset.create_hint(self)
	label.text = str(pack.count)
	if pack.count > 0:
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
		var follower := MouseFollower.create(item_preset.texture, item_preset, self)
		_field.start_drag(follower)

class_name ItemViewer extends Control

@export var item_preset : ItemPreset = null


var _hint : Hint = null


func _ready() -> void:
	set_item(item_preset)


func set_modular_color(color : Color) -> void:
	$TextureRect.self_modulate = color


func set_item(item : ItemPreset) -> void:
	item_preset = item
	if item:
		$TextureRect.texture = item.texture
		_hint = item.create_hint(self)
	else:
		$TextureRect.texture = null
		_hint = null


func get_hint_under_cursor(rect : Rect2) -> Hint:
	var self_rect := Rect2(global_position, size)
	if self_rect.intersects(rect):
		return _hint
	return null

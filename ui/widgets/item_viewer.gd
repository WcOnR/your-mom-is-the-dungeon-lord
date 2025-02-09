class_name ItemViewer extends Control

@export var item_preset : ItemPreset = null


func _ready() -> void:
	set_item(item_preset)


func set_modular_color(color : Color) -> void:
	$TextureRect.self_modulate = color


func set_item(item : ItemPreset) -> void:
	item_preset = item
	if item:
		$TextureRect.texture = item.texture
	else:
		$TextureRect.texture = null

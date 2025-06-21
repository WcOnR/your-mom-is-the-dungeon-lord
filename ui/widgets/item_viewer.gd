class_name ItemViewer extends Control

@export var item_preset : ItemPreset = null


func _ready() -> void:
	set_item(item_preset)


func set_item(item : ItemPreset) -> void:
	item_preset = item
	if item:
		$TextureRect.texture = item.texture
	else:
		$TextureRect.texture = null


func set_gray_out(gray_out : bool) -> void:
	$TextureRect.modulate = Color.DIM_GRAY if gray_out else Color.WHITE

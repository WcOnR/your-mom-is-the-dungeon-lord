class_name ConsumableItemHolder extends Control

@export var item_preset : ItemPreset = null
@onready var viewer : ItemViewer = $ItemViewer
@onready var label : Label = $ItemViewer/CountLabel


func _ready() -> void:
	viewer.set_item(item_preset)
	viewer.set_modular_color(Color.DIM_GRAY)

func set_pack(pack : ItemPack) -> void:
	label.text = str(pack.count)
	if pack.count > 0:
		viewer.set_modular_color(Color.WHITE)
	else:
		viewer.set_modular_color(Color.DIM_GRAY)
	

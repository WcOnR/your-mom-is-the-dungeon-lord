class_name ConsumableItemHolder extends Control

@export var item_preset : ItemPreset = null
@onready var viewer : ItemViewer = $ItemViewer
@onready var label : Label = $ItemViewer/CountLabel

var _field : Field = null
var _pack : ItemPack = null


func _ready() -> void:
	viewer.set_item(item_preset)
	viewer.set_modular_color(Color.DIM_GRAY)


func set_field(field : Field) -> void:
	_field = field


func set_pack(pack : ItemPack) -> void:
	_pack = pack
	label.text = str(pack.count)
	if pack.count > 0:
		viewer.set_modular_color(Color.WHITE)
	else:
		viewer.set_modular_color(Color.DIM_GRAY)


func _on_button_button_down() -> void:
	if _pack.count > 0:
		var follower := MouseFollower.create(item_preset.texture, item_preset, self)
		_field.start_drag(follower)

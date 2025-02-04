class_name ActionUI extends MarginContainer

@export var default_texture : Texture2D

@onready var img : TextureRect = $ActionImg
@onready var value_label : Label = $ActionImg/ActionLabel

var show_img_with_zero : bool = false
var _value : int = 0

func _ready() -> void:
	set_img(default_texture)



func set_img(_texture : Texture2D) -> void:
	img.texture = _texture


func set_value(value : int) -> void:
	_value = value
	visible = value == 0 and show_img_with_zero or value > 0
	value_label.visible = value > 0
	value_label.text = str(value)


func get_value() -> int:
	return _value

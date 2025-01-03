class_name ActionUI extends MarginContainer

@export var default_texture : Texture2D

@onready var img : TextureRect = $ActionImg
@onready var value_label : Label = $ActionImg/ActionLabel


func _ready() -> void:
	set_img(default_texture)



func set_img(_texture : Texture2D) -> void:
	img.texture = _texture


func set_value(value : float) -> void:
	visible = value > 0
	value_label.text = str(value)

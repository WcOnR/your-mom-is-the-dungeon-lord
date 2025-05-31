class_name ActionUI extends MarginContainer

@export var default_texture : Texture2D

@onready var img : TextureRect = $ActionImg
@onready var value_label : Label = $ActionImg/ActionLabel

var show_img_with_zero : bool = false
var _value : int = 0
var tween : Tween = null

func _ready() -> void:
	set_img(default_texture)
	modulate.a = 0.0



func set_img(_texture : Texture2D) -> void:
	img.texture = _texture


func set_value(value : int) -> void:
	_value = value
	var is_shown := value == 0 and show_img_with_zero or value > 0
	if tween:
		tween.stop()
	tween = create_tween()
	if is_shown:
		tween.tween_property(self, "modulate:a", 0.5, 0.01)
		tween.tween_property(self, "modulate:a", 1.0, 0.1)
	else:
		tween.tween_property(self, "modulate:a", 0.0, 0.1)
	value_label.visible = value > 0
	value_label.text = str(value)


func get_value() -> int:
	return _value

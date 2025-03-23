class_name ButtonWithIcon extends MarginContainer

@onready var button : Button = $Button
@onready var icon : TextureRect = $Icon


func get_btn() -> Button:
	var tmp : Button = $Button
	return tmp

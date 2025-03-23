class_name BottomBtnsPanel extends MarginContainer

@export var icons : Array[Texture] = []


func _ready() -> void:
	for i in icons.size():
		get_btn(i).icon.texture = icons[i]


func get_btn(index : int) -> ButtonWithIcon:
	var btns : Array[ButtonWithIcon] = [$HBoxContainer2/ButtonWithIcon, $HBoxContainer2/ButtonWithIcon2, $HBoxContainer2/ButtonWithIcon3]
	return btns[index]

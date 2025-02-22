class_name PickUpBonus extends Area2D

@export var bonus : NodePath

signal picked_up

var _is_enabled := true


func _ready() -> void:
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func _on_click_action(_data : ClickData) -> void:
	if _is_enabled and _is_click_on_me(_data):
		picked_up.emit()
		get_node(bonus).visible = false
		_is_enabled = false


func _is_click_on_me(_data : ClickData) -> bool:
	var space = get_world_2d().direct_space_state
	var collider := GameInputManagerSystem.is_click_on_area(space, _data)
	return collider == self

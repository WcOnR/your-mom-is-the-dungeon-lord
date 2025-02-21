class_name PickUpBonus extends Area2D

signal picked_up


func _ready() -> void:
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func _on_click_action(_data : ClickData) -> void:
	if _is_click_on_me(_data):
		picked_up.emit()


func _is_click_on_me(_data : ClickData) -> bool:
	var space = get_world_2d().direct_space_state
	var collider := GameInputManagerSystem.is_click_on_area(space, _data)
	return collider == self

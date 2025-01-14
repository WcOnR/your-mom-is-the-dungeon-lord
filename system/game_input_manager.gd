class_name GameInputManager extends Node

static var enabled : bool = true

var click_data : ClickData = null

signal on_click_start(ClickData)
signal on_click_end(ClickData)

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	if event.is_action_pressed("click"):
		click_data = ClickData.new()
		click_data.start_position = get_viewport().get_mouse_position()
		on_click_start.emit(click_data)
	if event.is_action_released("click"):
		click_data.end_position = get_viewport().get_mouse_position()
		on_click_end.emit(click_data)
		click_data = null

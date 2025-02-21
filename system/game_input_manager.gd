class_name GameInputManager extends Node

const HOLD_ON_TIME := 0.3


var click_data : ClickData = null
var last_position : Vector2 = Vector2.ZERO
var hold_on_timer : Timer = null


signal on_click_start(ClickData)
signal on_click_end(ClickData)
signal on_hold_on()


func _ready() -> void:
	hold_on_timer = Timer.new()
	hold_on_timer.one_shot = true
	add_child(hold_on_timer)
	hold_on_timer.timeout.connect(_on_hold_on_timeout)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		click_data = ClickData.new()
		click_data.start_position = get_viewport().get_mouse_position()
		on_click_start.emit(click_data)
	if event.is_action_released("click"):
		click_data.end_position = get_viewport().get_mouse_position()
		on_click_end.emit(click_data)
		click_data = null
	if event is InputEventMouse:
		hold_on_timer.stop()
		last_position = event.position
		hold_on_timer.start(HOLD_ON_TIME)


func _on_hold_on_timeout() -> void:
	on_hold_on.emit()


func is_click_on_area(space : PhysicsDirectSpaceState2D, data : ClickData) -> Area2D:
	var pp := PhysicsPointQueryParameters2D.new()
	pp.collide_with_areas = true 
	pp.position = data.start_position
	var start_point := space.intersect_point(pp, 1)
	pp.position = data.end_position
	var end_point := space.intersect_point(pp, 1)
	var is_hit := not (start_point.is_empty() or end_point.is_empty())
	if is_hit and start_point[0].collider == end_point[0].collider:
		return start_point[0].collider
	return null

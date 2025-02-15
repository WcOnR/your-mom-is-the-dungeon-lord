class_name HintLayer extends Control


const DEAD_ZONE := Vector2(10.0, 10.0)
const HIDE_TIME := 0.3
const MIN_HINT_SIZE := 200.0
const MAX_HINT_SIZE := 800.0


@onready var hint_ctrl := %Hint
@onready var hint_bg := %BgPanel
@onready var hint_title := %NameLabel
@onready var hint_description := %DescriptionLabel


var current_hint : Hint = null
var current_holder : Node = null
var hide_timer : Timer = null


func _ready() -> void:
	hint_ctrl.visible = false
	hide_timer = Timer.new()
	hide_timer.one_shot = true
	add_child(hide_timer)
	hide_timer.timeout.connect(_on_hide_timer_timeout)
	GameInputManagerSystem.on_hold_on.connect(_on_hold_on)


func _process(_delta: float) -> void:
	if current_hint and hide_timer.is_stopped():
		if not _is_still_in_bounds():
			hide_timer.start(HIDE_TIME)


func _is_still_in_bounds() -> bool:
	var rect := _get_cursor_rect()
	if hint_ctrl.visible and rect.intersects(_self_rect()):
		return true
	if current_hint != null and current_hint.holder != null:
		if current_hint == current_hint.holder.get_hint_under_cursor(rect):
			return true
	return false


func _get_hint_under_cursor() -> Hint:
	var rect := _get_cursor_rect()
	if hint_ctrl.visible and rect.intersects(_self_rect()):
		return current_hint
	var hint_holders := get_tree().get_nodes_in_group("HintTarget")
	for hint_holder in hint_holders:
		var hint : Hint = hint_holder.get_hint_under_cursor(rect)
		if hint:
			return hint
	return null


func _get_cursor_rect() -> Rect2:
	var pos := get_global_mouse_position()
	return Rect2(pos - DEAD_ZONE * 0.5, DEAD_ZONE)


func _self_rect() -> Rect2:
	return Rect2(hint_ctrl.global_position, hint_ctrl.size)


func _update_hint() -> void:
	if not current_hint:
		hint_ctrl.visible = false
		return
	var pos = get_global_mouse_position()
	hint_title.text = current_hint.title
	hint_description.text = current_hint.description
	var f : float = _get_fitting_factor(current_hint.description.length())
	hint_description.custom_minimum_size.x = lerpf(MIN_HINT_SIZE, MAX_HINT_SIZE, f)
	hint_ctrl.visible = true
	hint_ctrl.size = Vector2(1.0, 1.0)
	hint_ctrl.global_position = _get_offset_position(pos)


func _get_offset_position(pos : Vector2) -> Vector2:
	var dead_zone_rect := Rect2(%DeadZone.position, %DeadZone.size)
	pos.x = clampf(pos.x, dead_zone_rect.position.x, dead_zone_rect.size.x)
	pos.y = clampf(pos.y, dead_zone_rect.position.y, dead_zone_rect.size.y)
	var dirs : Array[Vector2] = [Vector2(1, 1), Vector2(1, 0), Vector2(0, 1), Vector2(0, 0)]
	for dir in dirs:
		var result : Vector2 = pos - hint_ctrl.size * dir
		if dead_zone_rect.encloses(Rect2(result, hint_ctrl.size)):
			return result
	return pos


func _get_fitting_factor(chars : int) -> float:
	const MIN_LENGTH := 22
	const DIF_TO_MAX_LENGTH := 62
	return min(1.0, max(chars - MIN_LENGTH, 0) / float(DIF_TO_MAX_LENGTH))


func _on_hold_on() -> void:
	var hint := _get_hint_under_cursor()
	if current_hint != hint:
		current_hint = hint
		_update_hint()


func _on_hide_timer_timeout() -> void:
	if _is_still_in_bounds():
		return
	current_hint = null
	_update_hint()

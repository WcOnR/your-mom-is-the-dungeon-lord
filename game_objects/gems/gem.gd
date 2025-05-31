class_name Gem extends Node2D

@onready var icon : Sprite2D = $Icon
@export var speed : float = 512.0

enum State {IDLE, FALL, MOVE, STOPPED}

signal state_changed

var _field : Field = null
var _state : State = State.IDLE
var _gem_type : GemType = null
var _target_cell : Vector2i = Grid.INVALID_ID


func initialize(cell_id : Vector2i, field : Field, gem_type : GemType) -> void:
	position = field.grid.get_cell_position(cell_id)
	_field = field
	_gem_type = gem_type
	icon.texture = gem_type.texture
	_field.grid.add_gem(self)
	_try_to_fall()


func destroy() -> void:
	_field.grid.remove_gem(self)
	get_parent().remove_child(self)
	queue_free()


func move_to_cell_id(cell_id : Vector2i) -> void:
	_target_cell = cell_id
	_set_state(State.MOVE)


func ready_to_idle() -> void:
	if is_state(State.STOPPED):
		_set_state(State.IDLE)


func get_gem_type() -> GemType:
	return _gem_type


func is_state(target_state : State) -> bool:
	return target_state == _state


func _set_state(new_state : State) -> void:
	if is_state(new_state):
		return
	_state = new_state
	if _state == State.IDLE:
		_target_cell = Grid.INVALID_ID
	if _state == State.MOVE:
		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "position", _field.grid.get_cell_position(_target_cell), 1.0)
		tween.tween_callback(_on_move_end)
	state_changed.emit()


func _process(delta: float) -> void:
	if is_state(State.STOPPED):
		return
	if is_state(State.IDLE):
		_try_to_fall()
		return
	if is_state(State.FALL):
		if _move_to_with_speed(self, _field.grid.get_cell_position(_target_cell), speed, delta):
			_try_to_fall()


func _on_move_end() -> void:
	if is_state(State.MOVE):
		_set_state(State.STOPPED)


func _move_to_with_speed(node : Node2D, to : Vector2, _speed : float, delta: float) -> bool :
	var dir := to - node.position
	var shift := delta * speed
	var length := dir.length()
	if length < 0.1 or length < shift:
		node.position = to
		return true
	dir = dir / length
	node.position += dir * shift
	return false


func _is_intersects(gem : Gem) -> bool:
	var _cell_size := _field.grid.get_cell_size()
	return Rect2(position, _cell_size).intersects(Rect2(gem.position, _cell_size))


func _test(offset : Vector2, target : Vector2i) -> float:
	var gems := _field.grid.get_intersects(position + offset)
	var target_gem : Gem = null
	for g in gems:
		if g != self and _field.grid.get_cell_id(g.position) == target:
			target_gem = g
	if target_gem:
		var new_offset := position.distance_to(target_gem.position) - _field.grid.get_cell_size().x
		return new_offset / offset.length()
	return 1.0


func _try_to_fall():
	var self_id := _field.grid.get_cell_id(position)
	var target := _field.get_next_cell(self_id)
	if target != Grid.INVALID_ID:
		var ray := _test(_field.grid.get_cell_position(target) - position, target)
		if ray > 0.01:
			_target_cell = target
			_set_state(State.FALL)
			return
	_set_state(State.IDLE)

class_name Gem extends Node2D

@onready var icon : Sprite2D = $Icon
@export var speed : float = 512.0

enum State {IDLE, FALL, MOVE}

signal state_changed

var _field : Field = null
var _state : State = State.IDLE
var _gem_type : GemType = null
var _cell_id : Vector2i = Field.INVALID_ID
var _target_cell : Vector2i = Field.INVALID_ID
var _blocked_id : Vector2i = Field.INVALID_ID



func initialize(cell_id : Vector2i, offset : Vector2, field : Field, gem_type : GemType) -> void:
	position = field.get_cell_position(cell_id) + offset
	_cell_id = cell_id
	_field = field
	_gem_type = gem_type
	icon.texture = gem_type.texture
	try_block()


func move_to_cell_id(cell_id : Vector2i) -> void:
	_cell_id = cell_id
	_target_cell = cell_id
	_blocked_id = Field.INVALID_ID
	_set_state(State.MOVE)


func try_to_fall():
	if not is_state(State.IDLE):
		return
	_try_to_fall()


func _try_to_fall():
	_target_cell = _field.get_next_cell(_cell_id)
	if _target_cell != Field.INVALID_ID:
		_set_state(State.FALL)
	else:
		_set_state(State.IDLE)
	try_block()


func try_block() -> void:
	var next_block := _target_cell if is_state(State.FALL) else _cell_id
	if next_block != _blocked_id:
		_field.block_cell(_blocked_id, null)
		_field.block_cell(next_block, self)
		_blocked_id = next_block


func get_cell_id() -> Vector2i:
	return _cell_id


func get_static_cell_id() -> Vector2i:
	return _cell_id if is_state(State.IDLE) else Field.INVALID_ID


func get_gem_type() -> GemType:
	return _gem_type


func is_state(target_state : State) -> bool:
	return target_state == _state


func _set_state(new_state : State) -> void:
	if is_state(new_state):
		return
	_state = new_state
	state_changed.emit()


func _process(delta: float) -> void:
	if is_state(State.IDLE):
		return
	if _move_to_with_speed(self, _field.get_cell_position(_target_cell), speed, delta):
		if is_state(State.FALL):
			_cell_id = _target_cell
			_try_to_fall()
		else:
			_cell_id = _target_cell
			_target_cell = Field.INVALID_ID
			_set_state(State.IDLE)
			try_block()


func _move_to_with_speed(node : Node2D, to : Vector2, _speed : float, delta: float) -> bool :
	var dir := to - node.position
	var length := dir.length()
	dir = dir / length
	node.position += dir * min(delta * speed, length)
	return node.position.distance_squared_to(to) < 1

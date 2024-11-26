class_name Gem extends Node2D

@onready var icon : Sprite2D = $Icon
@export var speed : float = 512.0

enum State {IDLE, FALL}


var _field : Field = null
var _state : State = State.IDLE
var _gem_type : GemType = null
var _cell_id : Vector2i = Field.INVALID_ID
var _target_cell : Vector2i = Field.INVALID_ID
var _blocked_id : Vector2i = Field.INVALID_ID


func initialize(cell_id : Vector2i, field : Field, gem_type : GemType) -> void:
	_cell_id = cell_id
	_field = field
	_gem_type = gem_type
	icon.texture = gem_type.texture
	try_block()


func try_to_fall():
	if _state == State.FALL:
		return
	_try_to_fall()


func _try_to_fall():
	_target_cell = _field.get_next_cell(_cell_id)
	if _target_cell != Field.INVALID_ID:
		_state = State.FALL
	else:
		_state = State.IDLE
	try_block()


func try_block() -> void:
	var next_block := _target_cell if _state == State.FALL else _cell_id
	if next_block != _blocked_id:
		_field.block_cell(_blocked_id, null)
		_field.block_cell(next_block, self)
		_blocked_id = next_block


func get_cell_id() -> Vector2i:
	return _cell_id


func get_static_cell_id() -> Vector2i:
	return _cell_id if _state == State.IDLE else Field.INVALID_ID


func get_gem_type() -> GemType:
	return _gem_type


func _process(delta: float) -> void:
	if _state == State.IDLE:
		return
	if _move_to_with_speed(self, _field.get_cell_position(_target_cell), speed, delta):
		_cell_id = _target_cell
		_try_to_fall()


func _move_to_with_speed(node : Node2D, to : Vector2, _speed : float, delta: float) -> bool :
	var dir := to - node.position
	var length := dir.length()
	dir = dir / length
	node.position += dir * min(delta * speed, length)
	return node.position.distance_squared_to(to) < 1

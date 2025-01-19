class_name AnimObject extends RefCounted

signal anim_finished

var _node : Node2D = null
var _pos : Vector2
var _curve : Curve = null
var _duration : float = -1.0
var _time_left : float = -1.0


func initialize(node : Node2D, curve : Curve, duration : float = 1.0) -> void:
	_node = node
	_pos = _node.position
	_curve = curve
	_duration = duration
	_time_left = duration


func update(delta : float) -> void:
	if _time_left <= 0.0:
		return
	_time_left = _time_left - delta
	var t : float = min((_duration - _time_left) / _duration, 1.0)
	_node.position = _pos + Vector2(0, _curve.sample(t))
	if _time_left <= 0.0:
		_node.position = _pos
		anim_finished.emit()
		

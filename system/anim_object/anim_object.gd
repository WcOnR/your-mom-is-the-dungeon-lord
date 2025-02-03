class_name AnimObject extends RefCounted

signal anim_finished

var _holder : Node
var _callback : Callable
var _curve : Curve = null
var _duration : float = -1.0
var _loop : bool = false
var _time_offset : float = -1.0
var _pause : bool = false


func _init(holder : Node, callback : Callable, curve : Curve, duration : float = 1.0) -> void:
	_holder = holder
	_callback = callback
	_curve = curve
	_duration = duration
	_time_offset = duration


func _update_one_shot(delta : float) -> bool:
	_time_offset = _time_offset - delta
	var t : float = min((_duration - _time_offset) / _duration, 1.0)
	_callback.call(_curve.sample(t))
	if _time_offset <= 0.0:
		anim_finished.emit()
		return true
	return false


func _update_loop(delta : float) -> bool:
	_time_offset = fmod(_time_offset + delta, _duration)
	var t : float = min(_time_offset / _duration, 1.0)
	_callback.call(_curve.sample(t))
	return false


func set_pause(pause : bool) -> void:
	_pause = pause


func set_loop(loop : bool, offset : float = -1.0) -> void:
	_loop = loop
	if _loop and offset >= 0.0:
		_time_offset = offset * _duration


func is_invalid() -> bool:
	return not _holder or _holder.is_queued_for_deletion()


func update(delta : float) -> bool:
	if _pause:
		return false
	if _loop:
		return _update_loop(delta)
	return _update_one_shot(delta)

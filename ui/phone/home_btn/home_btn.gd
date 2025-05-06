class_name HomeBtn extends TextureButton

@export var normal_color : Color
@export var active_color : Color
@export var disable_color : Color

enum State {NORMAL, ACTIVE, DISABLED}

var _state : State = State.NORMAL
var _is_active : bool = true


func set_state(new_state : State) -> void:
	if new_state == _state:
		return
	_set_state(new_state)


func set_main_state(active : bool) -> void:
	_is_active = active
	_set_state(_state)


func _set_state(new_state : State) -> void:
	_state = new_state
	if _is_active:
		if _state == State.ACTIVE:
			%RingTexture.modulate = active_color
		elif _state == State.NORMAL:
			%RingTexture.modulate = normal_color
		else:
			%RingTexture.modulate = disable_color
		disabled = _state == State.DISABLED
	else:
		%RingTexture.modulate = disable_color
		disabled = true

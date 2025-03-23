class_name HomeBtn extends Button

@export var normal_theme : Theme
@export var active_theme : Theme


enum State {NORMAL, ACTIVE, DISABLED}

var _state : State = State.NORMAL

func set_state(new_state : State) -> void:
	if new_state == _state:
		return
	_state = new_state
	set_theme(active_theme if _state == State.ACTIVE else normal_theme)
	disabled = _state == State.DISABLED

class_name EndTurnBtn extends Button

@export var normal_theme : Theme
@export var no_moves_theme : Theme


enum State {NORMAL, NO_MOVES, DISABLED}

var _state : State = State.NORMAL


func update_state(game_mode : BattleGameMode) -> void:
	if not game_mode.is_state(BattleGameMode.State.PLAYER_MOVE):
		_change_state(State.DISABLED)
	else:
		_change_state(State.NORMAL if game_mode.turns_left() else State.NO_MOVES)


func _change_state(new_state : State) -> void:
	if new_state == _state:
		return
	_state = new_state
	set_theme(no_moves_theme if _state == State.NO_MOVES else normal_theme)
	disabled = _state == State.DISABLED

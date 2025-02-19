class_name BattleGameMode extends Node


@export var line_holder : NodePath
@export var field : NodePath

enum State {NOT_STARTED, PLAYER_MOVE, ENEMY_MOVE, COLLECTING_REWARD, WIN, LOST}


var _line_holder : LineHolder = null
var _player : Player = null
var _field : Field = null
var _health_comp : HealthComp = null
var _turns_left : int = 0
var _state : State = State.NOT_STARTED
var _preset : BattlePreset = null
var _is_elite_battle := false

var _reward : Array[ItemPack] = []
var _equip_reward : Array[ItemPreset] = []

const EXTRA_TURNS : int = 2

signal state_changed
signal turn_changed
signal max_turn_changed
signal reward_granted


func _ready() -> void:
	_line_holder = get_node(line_holder) as LineHolder
	_field = get_node(field) as Field
	state_changed.connect(_update_field_input)
	turn_changed.connect(_update_field_input)
	_line_holder.active_lines_changed.connect(func(): max_turn_changed.emit())


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_W):
		_line_holder.debug_kill_all()


func start_battle(preset : BattlePreset, is_elite : bool) -> void:
	_preset = preset
	_is_elite_battle = is_elite
	await get_tree().process_frame
	_player = get_tree().get_first_node_in_group("Player") as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	_health_comp._drop_shield()
	_line_holder.spawn_enemies(preset)
	_line_holder.all_enemy_all_dead.connect(_on_win)
	_health_comp.death.connect(_on_lost)
	_field.action_clicked.connect(_next_turn)
	_start_round()


func finish_round() -> void:
	if is_state(State.ENEMY_MOVE):
		return
	_set_state(State.ENEMY_MOVE)
	if not _field.grid.is_idle():
		await _field.grid.grid_idle
	await _line_holder.enemy_attack()
	_health_comp._drop_shield()
	_start_round()


func turns_left() -> int:
	return _turns_left


func get_max_turns() -> int:
	return _line_holder.get_active_lines_count() + EXTRA_TURNS


func is_state(state : State) -> bool:
	return state == _state


func finish_battle(equip_choice : ItemPreset) -> void:
	if is_state(State.COLLECTING_REWARD):
		for r in _reward:
			_player.inventory_comp.add_pack(r)
		if equip_choice:
			_player.inventory_comp.add_item(equip_choice)
		SceneLoaderSystem.unload_room()


func get_reward() -> Array[ItemPack]:
	return _reward


func get_equip_reward() -> Array[ItemPreset]:
	return _equip_reward


func _set_state(new_state : State) -> void:
	if _state == new_state:
		return
	_state = new_state
	state_changed.emit()


func _end_game(is_win : bool) -> void:
	_set_state(State.WIN if is_win else State.LOST)
	_line_holder.all_enemy_all_dead.disconnect(_on_win)
	_health_comp.death.disconnect(_on_lost)


func _start_round() -> void:
	if is_state(State.COLLECTING_REWARD) or is_state(State.WIN) or is_state(State.LOST):
		return
	_field.clean_icons()
	_set_state(State.PLAYER_MOVE)
	_turns_left = get_max_turns()
	turn_changed.emit()


func _end_round() -> void:
	pass


func _next_turn() -> void:
	_turns_left -= 1
	turn_changed.emit()


func _update_field_input() -> void:
	var is_turns_left := _turns_left > 0
	var is_player_move := is_state(State.PLAYER_MOVE)
	_field.enable_input(is_player_move and is_turns_left)


func _on_win() -> void:
	if SceneLoaderSystem.is_next_room():
		_prepare_reward()
	else:
		print("you win")
		_end_game(true)


func _on_lost() -> void:
	print("you lost")
	_end_game(false)


func _prepare_reward() -> void:
	_set_state(State.COLLECTING_REWARD)
	var calculator := RewardCalculator.new()
	_reward = calculator.get_rewards(_preset)
	if _is_elite_battle:
		_equip_reward = calculator.get_equip_choice(_player.inventory_comp)
	reward_granted.emit()

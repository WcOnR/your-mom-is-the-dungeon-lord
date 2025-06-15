class_name BattleGameMode extends Node


@export var battle_fade : NodePath


enum State {NOT_STARTED, PLAYER_MOVE, ENEMY_MOVE, COLLECTING_REWARD, WIN, LOST}


var _line_holder : LineHolder = null
var _player : Player = null
var _field : Field = null
var _health_comp : HealthComp = null
var _turns_left : int = 0
var _state : State = State.NOT_STARTED
var _preset : BattlePreset = null
var _is_elite_battle := false
var _phone : Phone = null
var _events : Dictionary = {}

var _reward : Array[ItemPack] = []
var _statistics : Array[StatisticsInfo] = []
var _total_score : int = 0
var _equip_reward : Array[ItemPreset] = []

const EXTRA_TURNS : int = 2

const IN_ONE_TURN : StringName = "in_one_turn"
const IN_ONE_HIT : StringName = "in_one_hit"
const IN_SELF_HIT : StringName = "in_self_hit"
const HEALCAP : StringName = "healcap"
const ATTACKCAP : StringName = "attackcap"
const SHIELDCAP : StringName = "shieldcap"
const SKULLCAP : StringName = "skullcap"
const FLAWLESS_VICTORY : StringName = "flawless_victory"

signal state_changed
signal turn_changed
signal max_turn_changed
signal reward_granted
signal battle_started
signal player_turn_started
signal enemies_turn_started
signal enemies_turn_finished


func _ready() -> void:
	_line_holder = get_tree().get_first_node_in_group("LineHolder")
	_field = get_tree().get_first_node_in_group("Field")
	state_changed.connect(update_field_input)
	turn_changed.connect(update_field_input)
	_line_holder.active_lines_changed.connect(func(): max_turn_changed.emit())


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_W):
		_line_holder.debug_kill_all()


func set_phone(phone : Phone) -> void:
	_phone = phone
	%BattleUIStateController.set_phone(phone)


func get_phone() -> Phone:
	return _phone


func get_line_holder() -> LineHolder:
	if not _line_holder:
		_line_holder = get_tree().get_first_node_in_group("LineHolder")
	return _line_holder


func start_battle(preset : BattlePreset, is_elite : bool) -> void:
	_preset = preset
	_is_elite_battle = is_elite
	await get_tree().process_frame
	_player = get_tree().get_first_node_in_group("Player") as Player
	_player.equipment_manager_comp.set_game_mode(self)
	_health_comp = _player.get_node("HealthComp") as HealthComp
	_health_comp._drop_shield()
	_health_comp.health_changed.connect(_on_player_health_changed)
	_health_comp.heal_cap.connect(_add_overhit.bind(HEALCAP))
	_health_comp.shield_cap.connect(_add_overhit.bind(SHIELDCAP))
	_health_comp.damage_cap.connect(_add_overhit.bind(SKULLCAP))
	_line_holder.spawn_enemies(preset)
	for line in _line_holder.lines:
		for enemy in line.enemies:
			enemy.health_comp.damage_cap.connect(_add_overhit.bind(ATTACKCAP))
	_line_holder.all_enemy_all_dead.connect(_battle_end.bind(true))
	_health_comp.death.connect(_battle_end.bind(false))
	_field.action_clicked.connect(_next_turn)
	_events[FLAWLESS_VICTORY] = _health_comp.health
	_events[IN_ONE_TURN] = null
	_events[IN_SELF_HIT] = 0
	SoundSystem.set_bg_state("main")
	battle_started.emit()
	_start_round()


func finish_round() -> void:
	if is_state(State.ENEMY_MOVE):
		return
	if IN_ONE_TURN in _events:
		_events.erase(IN_ONE_TURN)
	_set_state(State.ENEMY_MOVE)
	if not _field.grid.is_idle():
		await _field.grid.grid_idle
	_field.clean_effects()
	enemies_turn_started.emit()
	await _line_holder.enemy_attack()
	enemies_turn_finished.emit()
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


func get_statistics() -> Array[StatisticsInfo]:
	return _statistics


func get_total_score() -> int:
	return _total_score


func get_reward() -> Array[ItemPack]:
	return _reward


func get_equip_reward() -> Array[ItemPreset]:
	return _equip_reward


func collect_statistics() -> void:
	_player.inventory_comp.add_currency(_total_score)


func add_self_killed_enemy() -> void:
	_events[IN_SELF_HIT] = _events[IN_SELF_HIT] + 1


func _add_overhit(overhit : StringName) -> void:
	if not overhit in _events:
		_events[overhit] = 0
	_events[overhit] = _events[overhit] + 1


func _set_state(new_state : State) -> void:
	if _state == new_state:
		return
	_state = new_state
	state_changed.emit()


func _battle_end(is_win : bool) -> void:
	_player.equipment_manager_comp.set_game_mode(null)
	_events[IN_ONE_HIT] = _line_holder.get_wasnt_move_enemies()
	if is_win:
		_on_win()
	else:
		_on_lost()


func _end_game(is_win : bool) -> void:
	_set_state(State.WIN if is_win else State.LOST)
	_line_holder.all_enemy_all_dead.disconnect(_battle_end)
	_health_comp.death.disconnect(_battle_end)
	if is_win:
		SoundSystem.set_bg_state("final")
		SceneLoaderSystem.load_win_scene()
	else:
		SoundSystem.set_bg_state("death")
		_final_screen_anim()


func _final_screen_anim() -> void:
	var panel := _phone.get_restart_panel()
	_phone.set_main_screen(panel)
	panel.end_game()
	var fade := get_node(battle_fade) as ColorRect
	var tween := get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color("0A0000", 1.0), 1.0)
	_phone.move_to_center()


func _start_round() -> void:
	if is_state(State.COLLECTING_REWARD) or is_state(State.WIN) or is_state(State.LOST):
		return
	_field.clean_icons()
	_set_state(State.PLAYER_MOVE)
	_turns_left = get_max_turns()
	turn_changed.emit()
	player_turn_started.emit()


func _end_round() -> void:
	pass


func _on_player_health_changed() -> void:
	if FLAWLESS_VICTORY in _events:
		if _events[FLAWLESS_VICTORY] <= _health_comp.health:
			_events[FLAWLESS_VICTORY] = _health_comp.health
		else:
			_events.erase(FLAWLESS_VICTORY)


func _next_turn() -> void:
	_turns_left -= 1
	turn_changed.emit()


func update_field_input() -> void:
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
	var stat = $RewardCalculator.get_statistics(_preset, _events)
	_total_score = stat[0]
	_statistics = stat[1]
	_reward = $RewardCalculator.get_rewards()
	if _is_elite_battle:
		_equip_reward = $RewardCalculator.get_equip_choice(_player.inventory_comp)
	reward_granted.emit()

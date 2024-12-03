class_name BattleGameMode extends Node


@export var line_holder : NodePath
@export var player : NodePath 
@export var field : NodePath

var _line_holder : LineHolder = null
var _player : Player = null
var _field : Field = null
var _health_comp : HealthComp = null
var turns_left : int = 0

const EXTRA_TURNS : int = 2

signal turn_changed


func _ready() -> void:
	_line_holder = get_node(line_holder) as LineHolder
	_player = get_node(player) as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	_field = get_node(field) as Field
	await get_tree().process_frame
	start_game()


func start_game() -> void:
	_line_holder.spawn_enemies()
	_line_holder.all_enemy_all_dead.connect(_on_win)
	_health_comp.death.connect(_on_lose)
	_field.gem_collapsed.connect(_next_turn)
	_start_round()


func _end_game() -> void:
	_line_holder.all_enemy_all_dead.disconnect(_on_win)
	_health_comp.death.disconnect(_on_lose)


func _start_round() -> void:
	turns_left = _line_holder.get_active_lines_count() + EXTRA_TURNS
	turn_changed.emit()
	_field.enable_input(true)


func _end_round() -> void:
	pass


func _next_turn() -> void:
	turns_left -= 1
	turn_changed.emit()
	if turns_left <= 0:
		_field.enable_input(false)


func finish_round() -> void:
	await _line_holder.enemy_attack()
	_health_comp._drop_shield()
	_start_round()


func _on_win() -> void:
	print("you win")
	_end_game()


func _on_lose() -> void:
	print("you lose")
	_end_game()

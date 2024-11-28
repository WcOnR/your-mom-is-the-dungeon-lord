class_name BattleGameMode extends Node


@export var line_holder : NodePath
@export var player : NodePath 

var _line_holder : LineHolder = null
var _player : Player = null
var _health_comp : HealthComp = null
var turns_left : int = 0


func _ready() -> void:
	_line_holder = get_node(line_holder)
	_player = get_node(player) as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	await get_tree().process_frame
	start_game()


func start_game() -> void:
	_line_holder.spawn_enemies()
	_line_holder.all_enemy_all_dead.connect(_on_win)
	_health_comp.death.connect(_on_lose)
	_start_turn()


func _end_game() -> void:
	_line_holder.all_enemy_all_dead.disconnect(_on_win)
	_health_comp.death.disconnect(_on_lose)


func _start_turn() -> void:
	turns_left = _line_holder.get_active_lines_count()
	print(turns_left)
	pass


func _end_turn() -> void:
	pass


func _on_win() -> void:
	print("you win")
	_end_game()


func _on_lose() -> void:
	print("you lose")
	_end_game()

class_name HUD extends Control

@export var game_mode : NodePath
@export var player : NodePath 

@onready var health_ui : HealthUI = $Panel/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/HealthUi
@onready var move_label : Label = $Panel/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MoveLabel


var _game_mode : BattleGameMode = null
var _player : Player = null
var _health_comp : HealthComp = null


func _ready() -> void:
	_game_mode = get_node(game_mode)
	_game_mode.turn_changed.connect(_on_turns_updates)
	_player = get_node(player) as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	health_ui.set_health_comp(_health_comp)


func _on_health_changed():
	health_ui.set_health(_health_comp.health)


func _on_turns_updates():
	move_label.text = str(_game_mode.turns_left)


func _on_end_round_btn_pressed() -> void:
	_game_mode.finish_round()

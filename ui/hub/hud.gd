class_name HUD extends Control

@export var game_mode : NodePath

@onready var health_ui : HealthUI = $Panel/HBoxContainer/RightSide/VBoxContainer/HealthUi
@onready var turn_tracker : TurnTracker = $Panel/HBoxContainer/BtnHolder/MarginContainer/TurnTracker
@onready var end_turn_btn : EndTurnBtn = $Panel/HBoxContainer/BtnHolder/EndTurnBtn


var _game_mode : BattleGameMode = null
var _player : Player = null
var _health_comp : HealthComp = null


func _ready() -> void:
	_game_mode = get_node(game_mode) as BattleGameMode
	_game_mode.turn_changed.connect(_on_turns_updates)
	_game_mode.max_turn_changed.connect(_on_max_turns_updates)
	_game_mode.state_changed.connect(_on_btn_state_changed)
	_player = get_tree().get_first_node_in_group("Player") as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	health_ui.set_health_comp(_health_comp)


func _on_health_changed():
	health_ui.set_health(_health_comp.health)


func _on_turns_updates():
	end_turn_btn.update_state(_game_mode)
	turn_tracker.update_state(_game_mode)


func _on_max_turns_updates():
	turn_tracker.update_state(_game_mode)


func _on_btn_state_changed():
	end_turn_btn.update_state(_game_mode)


func _on_end_turn_btn_pressed() -> void:
	_game_mode.finish_round()

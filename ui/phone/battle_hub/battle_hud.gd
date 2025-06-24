class_name BattleHUD extends Control


@onready var health_ui : HealthUI = %HealthUi
@onready var turn_tracker : TurnTracker = %TurnTracker
@onready var equip_btn : Button = %EquipButton


enum State {BATTLE, STATISTIC, ITEM, EQUIP, NEXT_ROUND, GAME_OVER}

var _game_mode : BattleGameMode = null
var _player : Player = null
var _health_comp : HealthComp = null
var _field : Field = null


func _ready() -> void:
	var game_mode : Node = get_tree().get_first_node_in_group("GameMode")
	if game_mode == null or not game_mode is BattleGameMode:
		return
	_game_mode = game_mode as BattleGameMode
	_game_mode.turn_changed.connect(_on_turns_updates)
	_game_mode.max_turn_changed.connect(_on_max_turns_updates)
	_player = get_tree().get_first_node_in_group("Player") as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	health_ui.set_health_comp(_health_comp)
	_field = get_tree().get_first_node_in_group("Field")
	equip_btn.pressed.connect(_on_equip_btn_pressed)
	if _player.inventory_comp.get_slots()[0] == null:
		equip_btn.visible = false
	


func enable_input(_enable_input : bool) -> void:
	_field.enable_input(_enable_input)


func _on_health_changed() -> void:
	health_ui.set_health(_health_comp.health)


func _on_turns_updates() -> void:
	turn_tracker.update_state(_game_mode)


func _on_max_turns_updates() -> void:
	turn_tracker.update_state(_game_mode)


func _on_equip_btn_pressed() -> void:
	var phone := _game_mode.get_phone()
	phone.add_to_panel_stack(phone.get_equipment_panel())

class_name HUD extends Control

@export var game_mode : NodePath
@export var field : NodePath

@onready var health_ui : HealthUI = %HealthUi
@onready var turn_tracker : TurnTracker = %TurnTracker
@onready var end_turn_btn : EndTurnBtn = %EndTurnBtn
@onready var reward_panel : RewardPanel = %RewardPanel
@onready var consumable_item_holders : Array[ConsumableItemHolder] = [%ConsumableItemHolder, %ConsumableItemHolder2, %ConsumableItemHolder3]


var _game_mode : BattleGameMode = null
var _player : Player = null
var _health_comp : HealthComp = null
var _field : Field = null


func _ready() -> void:
	_game_mode = get_node(game_mode) as BattleGameMode
	_game_mode.turn_changed.connect(_on_turns_updates)
	_game_mode.max_turn_changed.connect(_on_max_turns_updates)
	_game_mode.state_changed.connect(_on_btn_state_changed)
	_game_mode.reward_granted.connect(_on_reward_granted)
	_player = get_tree().get_first_node_in_group("Player") as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	health_ui.set_health_comp(_health_comp)
	reward_panel.collected.connect(_on_reward_collected)
	_player.inventory_comp.items_changed.connect(_on_item_updated)
	_field = get_node(field) as Field
	for holder in consumable_item_holders:
		holder.set_field(_field)
	_on_item_updated()


func _on_health_changed() -> void:
	health_ui.set_health(_health_comp.health)


func _on_turns_updates() -> void:
	end_turn_btn.update_state(_game_mode)
	turn_tracker.update_state(_game_mode)


func _on_max_turns_updates() -> void:
	turn_tracker.update_state(_game_mode)


func _on_btn_state_changed() -> void:
	end_turn_btn.update_state(_game_mode)


func _on_reward_granted() -> void:
	reward_panel.set_reward_view(_game_mode.get_reward())
	reward_panel.set_equip_choice(_game_mode.get_equip_reward())
	reward_panel.visible = true


func _on_reward_collected(equip_choice : ItemPreset) -> void:
	_game_mode.finish_battle(equip_choice)


func _on_end_turn_btn_pressed() -> void:
	_game_mode.finish_round()


func _on_item_updated() -> void:
	for holder in consumable_item_holders:
		var preset := holder.item_preset
		var pack := _player.inventory_comp.get_pack(preset)
		holder.set_pack(pack)
	%EquipViewer.update_view(_player.inventory_comp)
	%CoinPanel.update_amount(_player.inventory_comp)

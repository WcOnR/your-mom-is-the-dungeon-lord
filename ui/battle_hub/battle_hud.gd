class_name BattleHUD extends Control


@onready var health_ui : HealthUI = %HealthUi
@onready var turn_tracker : TurnTracker = %TurnTracker
@onready var home_btn : HomeBtn = %HomeBtn
@onready var battle_view : Control = %BattleView
@onready var statistics_panel : StatisticsPanel = %StatisticsPanel
@onready var item_panel : ItemLootPanel = %ItemLootPanel
@onready var equip_loot_panel : EquipLootPanel = %EquipLootPanel

@onready var bottom_btns_panel : BottomBtnsPanel = %BottomBtnsPanel 
@onready var equipment_panel : EquipmentPanel = %EquipmentPanel
@onready var settings_panel : Control = %SettingsPanel
@onready var consumable_panel : ConsumablePanel = %ConsumablePanel

enum State {BATTLE, STATISTIC, ITEM, EQUIP, NEXT_ROUND, GAME_OVER}
enum View {SETTINGS, BATTLE, EQUIP}

var _game_mode : BattleGameMode = null
var _player : Player = null
var _health_comp : HealthComp = null
var _field : Field = null
var _state : State = State.BATTLE
var _view : View = View.BATTLE
var _equip_choice : ItemPreset = null


func _ready() -> void:
	var game_mode : Node = get_tree().get_first_node_in_group("GameMode")
	if game_mode == null or not game_mode is BattleGameMode:
		visible = false
		return
	_game_mode = game_mode as BattleGameMode
	_game_mode.turn_changed.connect(_on_turns_updates)
	_game_mode.max_turn_changed.connect(_on_max_turns_updates)
	_game_mode.state_changed.connect(_on_btn_state_changed)
	_game_mode.reward_granted.connect(_on_reward_granted)
	_player = get_tree().get_first_node_in_group("Player") as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	health_ui.set_health_comp(_health_comp)
	_field = get_tree().get_first_node_in_group("Field")
	home_btn.pressed.connect(_on_home_btn_pressed)
	bottom_btns_panel.get_btn(0).get_btn().pressed.connect(_show_settings)
	bottom_btns_panel.get_btn(1).get_btn().pressed.connect(_show_spells)
	bottom_btns_panel.get_btn(2).get_btn().pressed.connect(_show_equipment)
	consumable_panel.begin_hold.connect(_on_begin_hold)


func _on_health_changed() -> void:
	health_ui.set_health(_health_comp.health)


func _on_turns_updates() -> void:
	turn_tracker.update_state(_game_mode)
	_update_home_btn()


func _on_max_turns_updates() -> void:
	turn_tracker.update_state(_game_mode)
	pass


func _on_btn_state_changed() -> void:
	_update_home_btn()


func _on_reward_granted() -> void:
	_update_state()
	_show_statistics()


func _show_statistics() -> void:
	settings_panel.visible = false
	equipment_panel.visible = false
	self.visible = true
	bottom_btns_panel.visible = false
	battle_view.visible = false
	statistics_panel.visible = true
	statistics_panel.show_info(_game_mode.get_statistics(), _player.inventory_comp)
	_update_home_btn()


func _show_items() -> void:
	statistics_panel.visible = false
	item_panel.set_reward_view(_game_mode.get_reward())
	item_panel.visible = true
	_update_home_btn()


func _show_equip() -> void:
	statistics_panel.visible = false
	item_panel.visible = false
	equip_loot_panel.set_reward_view(_game_mode.get_equip_reward())
	equip_loot_panel.selection_changed.connect(_on_equip_selection_changed)
	equip_loot_panel.visible = true
	_update_home_btn()


func _on_equip_selection_changed() -> void:
	_update_home_btn()


func _update_state() -> void:
	if _state == State.BATTLE:
		_state = State.STATISTIC
	else:
		var has_reward := not _game_mode.get_reward().is_empty()
		var has_equip_reward := not _game_mode.get_equip_reward().is_empty()
		var item_next_stage := State.EQUIP if has_equip_reward else State.NEXT_ROUND
		if _state == State.STATISTIC:
			_state = State.ITEM if has_reward else item_next_stage
		elif _state == State.ITEM:
			_state = item_next_stage
		elif _state == State.EQUIP:
			_state = State.NEXT_ROUND


func _on_home_btn_pressed() -> void:
	if _state == State.BATTLE:
		_game_mode.finish_round()
		return
	if _state == State.EQUIP:
		_equip_choice = equip_loot_panel.get_selected_equip()
	_update_state()
	if _state == State.ITEM:
		_show_items()
	elif _state == State.EQUIP:
		_show_equip()
	elif _state == State.NEXT_ROUND:
		_game_mode.finish_battle(_equip_choice)


func _update_home_btn() -> void:
	if _state == State.BATTLE:
		if not _game_mode.is_state(BattleGameMode.State.PLAYER_MOVE):
			home_btn.set_state(HomeBtn.State.DISABLED)
		else:
			var state := HomeBtn.State.NORMAL if _game_mode.turns_left() else HomeBtn.State.ACTIVE
			home_btn.set_state(state)
	elif _state == State.STATISTIC:
		home_btn.set_state(HomeBtn.State.ACTIVE)
	elif _state == State.EQUIP:
		if equip_loot_panel.get_selected_equip():
			home_btn.set_state(HomeBtn.State.ACTIVE)
		else:
			home_btn.set_state(HomeBtn.State.DISABLED)


func _hide_all_views() -> void:
	equipment_panel.visible = false
	settings_panel.visible = false
	self.visible = false


func _on_begin_hold() -> void:
	consumable_panel.visible = false
	_field.enable_input(true)


func _show_settings() -> void:
	_hide_all_views()
	consumable_panel.visible = false
	if _view == View.SETTINGS:
		self.visible = true
		_view = View.BATTLE
		_game_mode.update_field_input()
	else:
		settings_panel.visible = true
		_view = View.SETTINGS


func _show_spells() -> void:
	_hide_all_views()
	self.visible = true
	consumable_panel.visible = not consumable_panel.visible
	_field.enable_input(not consumable_panel.visible)
	_view = View.BATTLE


func _show_equipment() -> void:
	_hide_all_views()
	consumable_panel.visible = false
	if _view == View.EQUIP:
		self.visible = true
		_view = View.BATTLE
		_game_mode.update_field_input()
	else:
		equipment_panel.visible = true
		_view = View.EQUIP

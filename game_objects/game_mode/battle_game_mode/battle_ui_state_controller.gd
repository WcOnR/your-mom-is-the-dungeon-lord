class_name BattleUIStateController extends Node

enum State {BATTLE, STATISTIC, ITEM, EQUIP, NEXT_ROUND, GAME_OVER}

var _state : State = State.BATTLE
var _phone : Phone = null
var _game_mode : BattleGameMode = null
var _equip_choice : ItemPreset = null


func set_phone(phone : Phone) -> void:
	_phone = phone
	_phone.set_main_screen(_phone.get_battle_hub())
	_game_mode = get_parent() as BattleGameMode
	_game_mode.state_changed.connect(_update_home_btn)
	_game_mode.turn_changed.connect(_update_home_btn)
	_game_mode.reward_granted.connect(_on_reward_granted)
	_phone.get_home_btn().pressed.connect(_on_home_btn_pressed)


func _show_statistics() -> void:
	var statistics_panel := _phone.get_statistics_panel()
	_phone.set_main_screen(statistics_panel)
	var _player = get_tree().get_first_node_in_group("Player") as Player
	statistics_panel.show_info(_game_mode.get_statistics(), _player.inventory_comp)
	_update_home_btn()


func _show_items() -> void:
	var item_loot_panel := _phone.get_item_loot_panel()
	_phone.set_main_screen(item_loot_panel)
	item_loot_panel.set_reward_view(_game_mode.get_reward()[0])#TODO rework
	_update_home_btn()


func _show_equip() -> void:
	var equip_loot_panel := _phone.get_equip_loot_panel()
	_phone.set_main_screen(equip_loot_panel)
	equip_loot_panel.set_reward_view(_game_mode.get_equip_reward())
	equip_loot_panel.selection_changed.connect(_update_home_btn)
	_update_home_btn()


func _on_reward_granted() -> void:
	_update_state()
	_show_statistics()


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
		var equip_loot_panel := _phone.get_equip_loot_panel()
		_equip_choice = equip_loot_panel.get_selected_equip()
	_update_state()
	if _state == State.ITEM:
		_show_items()
	elif _state == State.EQUIP:
		_show_equip()
	elif _state == State.NEXT_ROUND:
		_game_mode.finish_battle(_equip_choice)


func _update_home_btn() -> void:
	var home_btn := _phone.get_home_btn()
	if _state == State.BATTLE:
		if not _game_mode.is_state(BattleGameMode.State.PLAYER_MOVE):
			home_btn.set_state(HomeBtn.State.DISABLED)
		else:
			var state := HomeBtn.State.NORMAL if _game_mode.turns_left() else HomeBtn.State.ACTIVE
			home_btn.set_state(state)
	elif _state == State.STATISTIC:
		home_btn.set_state(HomeBtn.State.ACTIVE)
	elif _state == State.EQUIP:
		var equip_loot_panel := _phone.get_equip_loot_panel()
		if equip_loot_panel.get_selected_equip():
			home_btn.set_state(HomeBtn.State.ACTIVE)
		else:
			home_btn.set_state(HomeBtn.State.DISABLED)

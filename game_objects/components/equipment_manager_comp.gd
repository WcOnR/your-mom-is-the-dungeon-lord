class_name EquipmentManagerComp extends Node

var _game_mode : BattleGameMode = null
var _inventory_com : InventoryComp = null
var _attack_com : AttackComp = null

const ON_ATTACK_APPLIED : StringName = "on_attack_applied"
const ON_BATTLE_START : StringName = "on_battle_start"
const ON_PLAYER_TURN_START : StringName = "on_player_turn_start"
const ON_ENEMIES_TURN_START : StringName = "on_enemies_turn_start"
const ON_ENEMIES_TURN_END : StringName = "on_enemies_turn_end"


func _ready() -> void:
	_inventory_com = get_parent().get_node("InventoryComp") as InventoryComp
	_attack_com = get_parent().get_node("AttackComp") as AttackComp
	_attack_com.attack_applied.connect(_on_attack_applied)


func set_game_mode(game_mode : BattleGameMode) -> void:
	if game_mode == _game_mode:
		return
	_disconnect_game_mode(_game_mode)
	_connect_game_mode(game_mode)
	_game_mode = game_mode


func get_game_mode() -> BattleGameMode:
	return _game_mode


func _connect_game_mode(game_mode : BattleGameMode) -> void:
	if game_mode == null:
		return
	game_mode.battle_started.connect(_on_battle_start)
	game_mode.player_turn_started.connect(_on_player_turn_start)
	game_mode.enemies_turn_started.connect(_on_enemies_turn_start)
	game_mode.enemies_turn_finished.connect(_on_enemies_turn_end)


func _disconnect_game_mode(game_mode : BattleGameMode) -> void:
	if game_mode == null:
		return
	game_mode.battle_started.disconnect(_on_battle_start)
	game_mode.player_turn_started.disconnect(_on_player_turn_start)
	game_mode.enemies_turn_started.disconnect(_on_enemies_turn_start)
	game_mode.enemies_turn_finished.disconnect(_on_enemies_turn_end)


func _run_actions(action : StringName) -> void:
	var slots := _inventory_com.get_slots()
	for slot in slots:
		if slot != null and slot.item_preset.action != null:
			slot.item_preset.action.run(action, [get_parent(), slot.count])


func _on_attack_applied(_applied_damage : int) -> void:
	_run_actions(ON_ATTACK_APPLIED)


func _on_battle_start() -> void:
	_run_actions(ON_BATTLE_START)


func _on_player_turn_start() -> void:
	_run_actions(ON_PLAYER_TURN_START)


func _on_enemies_turn_start() -> void:
	_run_actions(ON_ENEMIES_TURN_START)


func _on_enemies_turn_end() -> void:
	_run_actions(ON_ENEMIES_TURN_END)

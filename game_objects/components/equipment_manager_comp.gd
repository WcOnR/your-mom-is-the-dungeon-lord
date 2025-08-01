class_name EquipmentManagerComp extends Node

var _game_mode : BattleGameMode = null
var _inventory_com : InventoryComp = null
var _attack_com : AttackComp = null


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


func _run_actions(foo : Callable) -> void:
	var slots := _inventory_com.get_slots()
	for slot in slots:
		if slot != null and slot.item_preset.action != null:
			foo.call(slot.item_preset.action, slot.count)


func _on_attack_applied(_applied_damage : int) -> void:
	_run_actions(func(i, c): i.on_attack_applied(get_parent(), c))


func _on_battle_start() -> void:
	_run_actions(func(i, c): i.on_battle_start(get_parent(), c))


func _on_player_turn_start() -> void:
	_run_actions(func(i, c): i.on_player_turn_start(get_parent(), c))


func _on_enemies_turn_start() -> void:
	_run_actions(func(i, c): i.on_enemies_turn_start(get_parent(), c))


func _on_enemies_turn_end() -> void:
	_run_actions(func(i, c): i.on_enemies_turn_end(get_parent(), c))

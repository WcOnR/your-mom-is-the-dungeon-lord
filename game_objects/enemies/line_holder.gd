class_name LineHolder extends Node2D

signal all_enemy_all_dead
signal active_lines_changed

@onready var lines : Array[BattleLine] = [$Line, $Line2, $Line3]
var selected_line : int = -1
var _active_lines_count : int = 0
var _player : Player = null
var _game_mode : BattleGameMode = null


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("Player") as Player
	_game_mode = get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	_game_mode.state_changed.connect(_on_game_mode_state_changed)
	GameInputManagerSystem.on_click_end.connect(_on_click_action)
	var i := 0
	while i < lines.size():
		lines[i].set_id(i)
		i += 1


func spawn_enemies(battle : BattlePreset) -> void:
	var enemy_data := [battle.line1, battle.line2, battle.line3]
	var i := 0
	while i < lines.size():
		lines[i].set_enemies(enemy_data[i])
		lines[i].enemy_dead.connect(_on_enemy_dead)
		i += 1
	_select_next_line()
	_update_active_lines()


func apply_damage(damage : int) -> void:
	var enemies := lines[selected_line].enemies
	if not enemies.is_empty():
		enemies[0].health_comp.apply_damage(damage)


func debug_kill_all() -> void:
	for line in lines:
		while not line.enemies.is_empty():
			await get_tree().create_timer(0.1).timeout
			if not line.enemies.is_empty():
				line.enemies[0].health_comp.apply_damage(999)


func get_active_lines_count() -> int:
	var i := 0
	for l in lines:
		if not l.enemies.is_empty():
			i += 1
	return i


func _on_game_mode_state_changed() -> void:
	if _game_mode.is_state(BattleGameMode.State.PLAYER_MOVE):
		_plan_next_enemy_attack()


func _select_next_line() -> void:
	lines[selected_line].select(false)
	var old_selected_line := selected_line
	selected_line = -1
	var i := 1
	while i < lines.size():
		var tmp := (old_selected_line + i) % lines.size()
		if not lines[tmp].enemies.is_empty():
			_selct_line(lines[tmp])
			break
		i += 1


func _selct_line(line : BattleLine) -> void:
	if line and not line.enemies.is_empty():
		lines[selected_line].select(false)
		line.select(true)
		var i := 0
		while i < lines.size():
			if lines[i] == line:
				selected_line = i
				break
			i += 1
	var target_enemy : Enemy = null
	if selected_line >= 0:
		if not lines[selected_line].enemies.is_empty():
			target_enemy = lines[selected_line].enemies[0]
	_player.set_enemy(target_enemy)


func _on_click_action(_data : ClickData) -> void:
	if not _game_mode.is_state(BattleGameMode.State.PLAYER_MOVE):
		return
	var space = get_world_2d().direct_space_state
	var collider := GameInputManagerSystem.is_click_on_area(space, _data)
	var new_select : BattleLine = null
	if collider:
		new_select = collider as BattleLine
	_selct_line(new_select)


func _on_enemy_dead() -> void:
	_update_active_lines()
	var enemies := lines[selected_line].enemies
	if enemies.is_empty():
		_select_next_line()
		if selected_line == -1:
			all_enemy_all_dead.emit()
	else:
		enemies[0].plan_next_attack(lines[selected_line])
		_player.set_enemy(enemies[0])


func _update_active_lines() -> void:
	var i := get_active_lines_count()
	if i != _active_lines_count:
		_active_lines_count = i
		active_lines_changed.emit()


func enemy_attack() -> void:
	for l in lines:
		if not l.enemies.is_empty():
			await l.enemies[0].attack(_player)
	await get_tree().process_frame


func _plan_next_enemy_attack() -> void:
	for l in lines:
		if not l.enemies.is_empty():
			l.enemies[0].plan_next_attack(l)

class_name LineHolder extends Node2D

@export var player : NodePath 
@export var battle : BattlePreset

signal all_enemy_all_dead

@onready var lines : Array[BattleLine] = [$Line, $Line2, $Line3, $Line4]
var selected_line : int = -1
var _player : Player = null


func _ready() -> void:
	_player = get_node(player) as Player
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func spawn_enemies() -> void:
	var enemy_data := [battle.line1, battle.line2, battle.line3, battle.line4]
	var i := 0
	while i < lines.size():
		lines[i].set_enemies(enemy_data[i])
		lines[i].enemy_dead.connect(_on_enemy_dead)
		i += 1
	_plan_next_enemy_attack()
	_select_next_line()


func apply_damage(damage : int) -> void:
	var enemies := lines[selected_line].enemies
	if not enemies.is_empty():
		enemies[0].health_comp.apply_damage(damage)


func get_active_lines_count() -> int:
	var i := 0
	for l in lines:
		if not l.enemies.is_empty():
			i += 1
	return i


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


func _on_click_action(_data : ClickData) -> void:
	var space = get_world_2d().direct_space_state
	var pp := PhysicsPointQueryParameters2D.new()
	pp.collide_with_areas = true 
	pp.position = _data.start_position
	var start_point := space.intersect_point(pp, 1)
	pp.position = _data.end_position
	var end_point := space.intersect_point(pp, 1)
	var new_select : BattleLine = null
	var is_hit := not (start_point.is_empty() or end_point.is_empty())
	if is_hit and start_point[0].collider == end_point[0].collider:
		new_select = start_point[0].collider as BattleLine
	_selct_line(new_select)


func _on_enemy_dead() -> void:
	var enemies := lines[selected_line].enemies
	if enemies.is_empty():
		_select_next_line()
		if selected_line == -1:
			all_enemy_all_dead.emit()
	else:
		enemies[0].plan_next_attack()


func enemy_attack() -> void:
	for l in lines:
		if not l.enemies.is_empty():
			l.enemies[0].attack(_player)
	await get_tree().process_frame


func _plan_next_enemy_attack() -> void:
	for l in lines:
		if not l.enemies.is_empty():
			l.enemies[0].plan_next_attack()

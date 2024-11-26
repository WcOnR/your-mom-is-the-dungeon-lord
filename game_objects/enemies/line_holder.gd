class_name LineHolder extends Node2D

@export var battle : BattlePreset

@onready var lines : Array[BattleLine] = [$Line, $Line2, $Line3, $Line4]
var selected_line : int = 0

func _ready() -> void:
	var enemy_data := [battle.line1, battle.line2, battle.line3, battle.line4]
	var i := 0
	while i < lines.size():
		lines[i].set_enemies(enemy_data[i])
		lines[i].enemy_dead.connect(_on_enemy_dead)
		i += 1
	lines[0].select(true)
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func apply_damage(damage : int) -> void:
	var enemies := lines[selected_line].enemies
	if not enemies.is_empty():
		enemies[0].health_comp.apply_damage(damage)


func _select_next_line() -> void:
	lines[selected_line].select(false)
	var i := 1
	while i < lines.size():
		var tmp := (selected_line + i) % lines.size()
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
	else:
		pass

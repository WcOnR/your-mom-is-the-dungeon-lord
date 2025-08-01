class_name TargetPositionAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/aim.png")
const FIELD_TARGET : StringName = "field_aim_target"
const LINE_ID : StringName = "line_id"

@export var selector : FieldSelector = null


func on_plan(enemy : Enemy, line : BattleLine) -> void:
	line.set_action(0, ICON, true)
	var game_mode := line.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle
	if enemy == null:
		return
	var cell_ids : Array[Vector2i] = selector.get_target_ids(field)
	enemy.memory[FIELD_TARGET] = cell_ids
	enemy.memory[LINE_ID] = line.get_id()
	for cell_id in cell_ids:
		field.show_icon(cell_id, CellIcons.Type.AIM, true, enemy.memory[LINE_ID])


func on_pre_action(enemy : Enemy, _player : Player) -> void:
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle


func on_action(enemy : Enemy, _player : Player) -> void:
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	var cell_ids : Array[Vector2i] = enemy.memory[FIELD_TARGET]
	for cell_id in cell_ids:
		if enemy == null or enemy.health_comp == null or enemy.health_comp.is_dead():
			return
		field.hit_target(cell_id, enemy)
		field.show_icon(cell_id, CellIcons.Type.AIM, false, enemy.memory[LINE_ID])


func on_death(enemy : Enemy) -> void:
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not FIELD_TARGET in enemy.memory:
		return
	var cell_ids : Array[Vector2i] = enemy.memory[FIELD_TARGET]
	for cell_id in cell_ids:
		field.show_icon(cell_id, CellIcons.Type.AIM, false, enemy.memory[LINE_ID])

class_name FieldPositionAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/aim_cells.png")
const GEM_TYPE : GemType = preload("res://game_objects/gems/attack_type.tres")
const FIELD_TARGET : StringName = "field_target"
const LINE_ID : StringName = "line_id"
const ARGS_BEGIN : int = 1


func on_plan(args : Array[Variant]) -> void:
	var selector := args[0] as FieldSelector
	var enemy : Enemy = args[ARGS_BEGIN] as Enemy
	var line : BattleLine = args[ARGS_BEGIN + 1] as BattleLine
	line.set_action(0, ICON, true)
	var game_mode := line.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle
	if enemy == null:
		return
	var cell_ids := selector.get_target_ids(field)
	enemy.memory[FIELD_TARGET] = cell_ids
	enemy.memory[LINE_ID] = line.get_id()
	for cell_id in cell_ids:
		field.show_icon(cell_id, CellIcons.Type.ATTACK, true, enemy.memory[LINE_ID])


func on_pre_action(args : Array[Variant]) -> void:
	var enemy : Enemy = args[ARGS_BEGIN] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle


func on_action(args : Array[Variant]) -> void:
	var enemy : Enemy = args[ARGS_BEGIN] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	var cell_ids : Array[Vector2i] = enemy.memory[FIELD_TARGET]
	field.collapse_ids(cell_ids, enemy)
	for cell_id in cell_ids:
		field.show_icon(cell_id, CellIcons.Type.ATTACK, false, enemy.memory[LINE_ID])


func on_death(args : Array[Variant]) -> void:
	var enemy : Enemy = args[ARGS_BEGIN] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not FIELD_TARGET in enemy.memory:
		return
	var cell_ids : Array[Vector2i] = enemy.memory[FIELD_TARGET]
	for cell_id in cell_ids:
		field.show_icon(cell_id, CellIcons.Type.ATTACK, false, enemy.memory[LINE_ID])

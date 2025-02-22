class_name GemTargetAttackAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/aim.png")
const GEM_TYPE : GemType = preload("res://game_objects/gems/attack_type.tres")
const TARGET : StringName = "target"
const LINE_ID : StringName = "line_id"


func on_plan(args : Array[Variant]) -> void:
	var enemy : Enemy = args[0] as Enemy
	var line : BattleLine = args[1] as BattleLine
	line.set_action(0, ICON, true)
	var game_mode := line.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle
	var cluster := field.get_max_gem_cluster_by_type(GEM_TYPE)
	enemy.memory[TARGET] = cluster.pick_random()
	enemy.memory[LINE_ID] = line.get_id()
	field.show_icon(enemy.memory[TARGET], CellIcons.Type.AIM, true, enemy.memory[LINE_ID])


func on_pre_action(args : Array[Variant]) -> void:
	var enemy : Enemy = args[0] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle


func on_action(args : Array[Variant]) -> void:
	var enemy : Enemy = args[0] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	field.hit_target(enemy.memory[TARGET], enemy)
	field.show_icon(enemy.memory[TARGET], CellIcons.Type.AIM, false, enemy.memory[LINE_ID])


func on_death(args : Array[Variant]) -> void:
	var enemy : Enemy = args[0] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	field.show_icon(enemy.memory[TARGET], CellIcons.Type.AIM, false, enemy.memory[LINE_ID])

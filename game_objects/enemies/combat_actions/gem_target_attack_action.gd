class_name GemTargetAttackAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/aim.png")
const GEM_TYPE : GemType = preload("res://game_objects/gems/attack_type.tres")

var target := Vector2i.ZERO

func on_plan(args : Array[Variant]) -> void:
	var line : BattleLine = args[1] as BattleLine
	line.set_action(0, ICON, true)
	var game_mode := line.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle
	var cluster := field.get_max_gem_cluster_by_type(GEM_TYPE)
	target = cluster.pick_random()
	field.show_icon(target, IconTileMapLayer.Type.CROSS)


func on_action(args : Array[Variant]) -> void:
	var enemy : Enemy = args[0] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	field.hit_target(target, enemy)
	field.show_icon(target, IconTileMapLayer.Type.NONE)
	if not field.grid.is_idle():
		await field.grid.grid_idle


func on_death(args : Array[Variant]) -> void:
	var enemy : Enemy = args[0] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	field.show_icon(target, IconTileMapLayer.Type.NONE)

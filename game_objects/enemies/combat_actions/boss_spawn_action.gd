class_name BossSpawnAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/spawn.png")
const LEFT_TENTACLE : EnemyData = preload("res://game_objects/enemies/tentacle/e_tentacle_left.tres")
const RIGHT_TENTACLE : EnemyData = preload("res://game_objects/enemies/tentacle/e_tentacle_right.tres")


func on_plan(args : Array[Variant]) -> bool:
	var line : BattleLine = args[1] as BattleLine
	line.set_action(0, ICON, true)
	return false


func on_action(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var holder := enemy.get_tree().get_first_node_in_group("LineHolder") as LineHolder
	holder.spawn_enemy_on_line(LEFT_TENTACLE, 0)
	holder.spawn_enemy_on_line(RIGHT_TENTACLE, 2)
	return false

class_name BoomAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/boom.png")


func on_plan(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var base_attack : int = enemy.enemy_data.damage
	var line : BattleLine = args[1] as BattleLine
	line.set_action(base_attack, ICON)
	return false


func on_action(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var base_attack : int = enemy.enemy_data.damage
	var player : Player = args[1] as Player
	var targets : Array[HealthComp] = [player.health_comp]
	var line_holder := enemy.get_tree().get_first_node_in_group("LineHolder") as LineHolder
	targets.append_array(line_holder.get_front_enemy_health_comp())
	for health_comp in targets:
		health_comp.apply_damage(base_attack)
	return false

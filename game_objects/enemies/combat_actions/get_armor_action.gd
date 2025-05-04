class_name GetArmorAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/shield.png")


func on_plan(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var base_attack : int = enemy.enemy_data.damage
	var line : BattleLine = args[1] as BattleLine
	line.set_action(base_attack * 2, ICON)
	return false


func on_action(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var base_attack : int = enemy.enemy_data.damage
	enemy.health_comp.add_shield(base_attack * 2)
	return false

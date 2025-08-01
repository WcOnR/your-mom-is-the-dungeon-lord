class_name VenomAttackAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/venom.png")


func on_plan(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var base_attack : int = enemy.enemy_data.damage
	var line : BattleLine = args[1] as BattleLine
	line.set_action(base_attack, ICON)
	return false


func on_action(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var attack_comp := enemy.attack_comp
	attack_comp.shield_penetration_bonus = 0.0001
	attack_comp.attack(enemy.enemy_data.damage)
	return false

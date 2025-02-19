class_name AttackAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/sword.png")


func on_plan(args : Array[Variant]) -> bool:
	var enemy_data : = args[0] as EnemyData
	var base_attack : int = enemy_data.damage
	var line : BattleLine = args[1] as BattleLine
	line.set_action(base_attack, ICON)
	return false


func on_action(args : Array[Variant]) -> bool:
	var enemy : = args[0] as Enemy
	var base_attack : int = enemy.enemy_data.damage
	var player : Player = args[1] as Player
	player.health_comp.apply_damage(base_attack)
	return false

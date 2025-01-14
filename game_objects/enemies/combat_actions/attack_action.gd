class_name AttackAction extends RefCounted

const ICON : Texture2D = preload("res://game_objects/gems/sword.tres")


func on_plan(args : Array[Variant]) -> bool:
	var enemy_data : = args[0] as EnemyData
	var base_attack : int = enemy_data.damage
	var line : BattleLine = args[1] as BattleLine
	line.set_action(base_attack, ICON)
	return false


func on_action(args : Array[Variant]) -> bool:
	var enemy_data : = args[0] as EnemyData
	var base_attack : int = enemy_data.damage
	#print("on attack ", base_attack)
	var player : Player = args[1] as Player
	player.health_comp.apply_damage(base_attack)
	return false

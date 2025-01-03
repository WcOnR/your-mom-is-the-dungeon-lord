class_name AttackAction extends RefCounted

const ICON : Texture2D = preload("res://game_objects/gems/sword.tres")


func on_plan(args : Array[Variant]) -> bool:
	var base_attack : int = args[0]
	var line : BattleLine = args[1] as BattleLine
	line.set_action(base_attack, ICON)
	return false


func on_action(args : Array[Variant]) -> bool:
	var base_attack : int = args[0]
	print("on attack ", base_attack)
	var player : Player = args[1] as Player
	player.health_comp.apply_damage(base_attack)
	return false

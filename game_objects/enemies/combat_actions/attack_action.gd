class_name AttackAction extends RefCounted


func on_plan(_args : Array[Variant]) -> bool:
	print("attack plned")
	return false


func on_action(args : Array[Variant]) -> bool:
	var base_attack : int = args[0]
	print("on attack ", base_attack)
	var player : Player = args[1] as Player
	player.health_comp.apply_damage(base_attack)
	return false

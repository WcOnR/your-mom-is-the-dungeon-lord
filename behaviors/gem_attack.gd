class_name GemAttack extends RefCounted

func on_action(args : Array[Variant]) -> bool:
	var base_attack : int = args[0]
	var gem_count : int = args[1]
	var line_holder : LineHolder = args[3] as LineHolder
	line_holder.apply_damage(base_attack * gem_count)
	return false

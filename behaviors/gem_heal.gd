class_name GemHeal extends RefCounted

func on_action(args : Array[Variant]) -> bool:
	var base_heal : int = args[0]
	var gem_count : int = args[1]
	var initiator := args[2] as Node
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	health_comp.apply_heal(base_heal * gem_count)
	return false

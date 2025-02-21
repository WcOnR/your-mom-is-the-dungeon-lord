class_name GemSkull extends RefCounted

func on_action(args : Array[Variant]) -> bool:
	var base_attack : int = args[0]
	var gem_count : int = args[1]
	var initiator := args[2] as Node
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	health_comp.apply_damage(base_attack * gem_count)
	return false

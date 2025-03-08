class_name GemSharpHeart extends RefCounted

func on_action(args : Array[Variant]) -> bool:
	var base_heal : float = args[0]
	var base_attack : float = args[1]
	var gem_count : float = args[2]
	var initiator := args[3] as Node
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	health_comp.apply_heal(ceili(base_heal * gem_count))
	var attack_comp := initiator.get_node("AttackComp") as AttackComp
	attack_comp.attack(ceili(base_attack * gem_count))
	return false

class_name GemAttack extends RefCounted

func on_action(args : Array[Variant]) -> bool:
	var base_attack : int = args[0]
	var gem_count : int = args[1]
	var initiator := args[2] as Node
	var attack_comp := initiator.get_node("AttackComp") as AttackComp
	attack_comp.attack(base_attack * gem_count)
	return false

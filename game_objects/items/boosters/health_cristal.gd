class_name HealthCristal extends Node

const PERCENT : float = 1.1

func on_pick_up(args : Array[Variant]) -> bool:
	var initiator := args[0] as Node
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	if health_comp:
		health_comp.set_max_health(ceil(health_comp.max_health * PERCENT))
	return false

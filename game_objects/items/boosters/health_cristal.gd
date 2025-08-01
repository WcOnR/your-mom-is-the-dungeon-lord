class_name HealthCristal extends ItemAction

const PERCENT : float = 1.2

func on_pick_up(initiator : Node) -> void:
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	if health_comp:
		health_comp.set_max_health(ceil(health_comp.max_health * PERCENT))

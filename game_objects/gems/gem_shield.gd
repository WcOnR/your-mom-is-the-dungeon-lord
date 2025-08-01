class_name GemShield extends GemAction

@export var base_bonus : int = 10


func on_action(gem_count : int, initiator : Node) -> void:
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	health_comp.add_shield(base_bonus * gem_count)

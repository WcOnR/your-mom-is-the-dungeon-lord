class_name GemHeal extends GemAction

@export var base_heal : int = 10


func on_action(gem_count : int, initiator : Node) -> void:
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	health_comp.apply_heal(base_heal * gem_count)

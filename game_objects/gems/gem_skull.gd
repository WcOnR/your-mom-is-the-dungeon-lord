class_name GemSkull extends GemAction

@export var base_attack : int = 10


func on_action(gem_count : int, initiator : Node) -> void:
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	health_comp.apply_damage(base_attack * gem_count)

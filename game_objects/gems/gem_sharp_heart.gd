class_name GemSharpHeart extends GemAction

@export var base_heal : int = 10
@export var base_attack : int = 10


func on_action(gem_count : int, initiator : Node) -> void:
	var health_comp := initiator.get_node("HealthComp") as HealthComp
	health_comp.apply_heal(ceili(base_heal * gem_count))
	var attack_comp := initiator.get_node("AttackComp") as AttackComp
	attack_comp.attack(ceili(base_attack * gem_count))

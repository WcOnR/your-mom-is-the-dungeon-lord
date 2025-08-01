class_name GemAttack extends GemAction

@export var base_attack : int = 10


func on_action(gem_count : int, initiator : Node) -> void:
	var attack_comp := initiator.get_node("AttackComp") as AttackComp
	attack_comp.attack(base_attack * gem_count)

class_name AttackComp extends Node


signal attack_applied(int)

var extra_attack_bonus : float = 0
var _target : HealthComp = null


func set_target(target : HealthComp) -> void:
	_target = target


func attack(value : int) -> void:
	if _target:
		var factor := 1 + extra_attack_bonus
		var applied_damage := _target.apply_damage(ceili(value * factor))
		attack_applied.emit(applied_damage)

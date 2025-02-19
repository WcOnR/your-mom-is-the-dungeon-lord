class_name AttackComp extends Node


var _target : HealthComp = null


func set_target(target : HealthComp) -> void:
	_target = target


func attack(value : int) -> void:
	if _target:
		_target.apply_damage(value)

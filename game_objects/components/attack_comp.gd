class_name AttackComp extends Node


signal attack_applied(int)

var extra_attack_bonus : float = 0.0
var shield_penetration_bonus : float = 1.0
var _target : HealthComp = null


func set_target(target : HealthComp) -> void:
	_target = target


func attack(value : int) -> void:
	if _target:
		var factor := 1 + extra_attack_bonus
		var damage := mini(ceili(value * factor), HealthComp.MAX_DAMAGE)
		var shield_cost := _target.shield / shield_penetration_bonus 
		if shield_penetration_bonus >= 100:
			shield_cost = 0.0
		if damage >= shield_cost:
			damage = damage - floori(shield_cost) + _target.shield
		else:
			damage = damage * ceili(shield_penetration_bonus)
		var applied_damage := _target.apply_damage(damage, true)
		attack_applied.emit(applied_damage)

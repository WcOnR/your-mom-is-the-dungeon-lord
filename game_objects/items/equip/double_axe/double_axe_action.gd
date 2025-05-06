class_name DoubleAxeAction extends RefCounted

func on_battle_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	var extra_attack_bonus : float = 1.25
	_player.attack_comp.extra_attack_bonus = extra_attack_bonus
	_player.attack_comp.shield_penetration_bonus = 100
	return false

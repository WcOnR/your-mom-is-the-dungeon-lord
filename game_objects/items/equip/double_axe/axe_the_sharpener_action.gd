class_name AxeTheSharpenerAction extends RefCounted

func on_battle_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	var extra_attack_bonus : Array[float] = [0.2, 0.5, 1.0]
	_player.attack_comp.extra_attack_bonus = extra_attack_bonus[_level - 1]
	return false

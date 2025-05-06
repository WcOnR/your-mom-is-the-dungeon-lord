class_name ShieldbreakerAction extends RefCounted


func on_battle_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	var shield_penetration_bonus : Array[float] = [2, 3, 4]
	_player.attack_comp.shield_penetration_bonus = shield_penetration_bonus[_level - 1]
	return false

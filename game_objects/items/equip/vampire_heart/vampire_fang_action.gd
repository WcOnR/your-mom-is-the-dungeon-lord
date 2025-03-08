class_name VampireFangAction extends RefCounted


func on_attack_applied(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	var healing : Array[float] = [0.01, 0.03, 0.05]
	var persent : float = healing[_level - 1]
	_player.health_comp.apply_heal(ceili(_player.health_comp.max_health * persent))
	return false

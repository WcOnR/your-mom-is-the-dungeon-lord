class_name VampireFangAction extends ItemAction


func on_attack_applied(_player : Player, _level : int) -> void:
	var healing : Array[float] = [0.01, 0.03, 0.05]
	var persent : float = healing[_level - 1]
	_player.health_comp.apply_heal(ceili(_player.health_comp.max_health * persent))

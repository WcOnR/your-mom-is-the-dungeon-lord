class_name AxeTheSharpenerAction extends ItemAction

func on_battle_start(_player : Player, _level : int) -> void:
	var extra_attack_bonus : Array[float] = [0.2, 0.4, 0.75]
	_player.attack_comp.extra_attack_bonus = extra_attack_bonus[_level - 1]

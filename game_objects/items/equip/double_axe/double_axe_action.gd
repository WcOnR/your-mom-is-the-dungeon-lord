class_name DoubleAxeAction extends ItemAction

func on_battle_start(_player : Player, _level : int) -> void:
	var extra_attack_bonus : float = 1.25
	_player.attack_comp.extra_attack_bonus = extra_attack_bonus
	_player.attack_comp.shield_penetration_bonus = 100

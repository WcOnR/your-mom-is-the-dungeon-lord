class_name ShieldbreakerAction extends ItemAction


func on_battle_start(_player : Player, _level : int) -> void:
	var shield_penetration_bonus : Array[float] = [2, 3, 4]
	_player.attack_comp.shield_penetration_bonus = shield_penetration_bonus[_level - 1]

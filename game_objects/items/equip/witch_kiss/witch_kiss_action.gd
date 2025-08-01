class_name WitchKissAction extends ItemAction


func on_battle_start(_player : Player, _level : int) -> void:
	var game_mode := _player.equipment_manager_comp.get_game_mode()
	var line_holder := game_mode.get_line_holder()
	for line in line_holder.lines:
		for i in line.enemies.size():
			line.enemies[i].set_paralyze()

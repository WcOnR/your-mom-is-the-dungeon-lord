class_name SilverEarringOfWitchAction extends ItemAction


func on_battle_start(_player : Player, _level : int) -> void:
	var game_mode := _player.equipment_manager_comp.get_game_mode()
	var line_holder := game_mode.get_line_holder()
	var line := line_holder.lines[2]
	var count : Array[int] = [1, 2, line.enemies.size()]
	for i in line.enemies.size():
		if i < count[_level - 1]:
			line.enemies[i].set_paralyze()

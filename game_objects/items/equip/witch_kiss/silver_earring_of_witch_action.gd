class_name SilverEarringOfWitchAction extends RefCounted


func on_battle_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	var game_mode := _player.equipment_manager_comp.get_game_mode()
	var line_holder := game_mode.get_line_holder()
	var line := line_holder.lines[2]
	var count : Array[int] = [1, 2, line.enemies.size()]
	for i in line.enemies.size():
		if i < count[_level - 1]:
			line.enemies[i].set_paralyze()
	return false

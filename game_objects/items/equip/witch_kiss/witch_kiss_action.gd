class_name WitchKissAction extends RefCounted


func on_battle_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	var game_mode := _player.equipment_manager_comp.get_game_mode()
	var line_holder := game_mode.get_line_holder()
	for line in line_holder.lines:
		for i in line.enemies.size():
			line.enemies[i].set_paralyze()
	return false

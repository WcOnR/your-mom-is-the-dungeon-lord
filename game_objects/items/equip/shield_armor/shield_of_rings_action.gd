class_name ShieldOfRings extends RefCounted


const RESTORED_SHIELDS : StringName = "restored_shields_shield_of_rings"


func on_player_turn_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	if RESTORED_SHIELDS in _player.memory:
		_player.health_comp.add_shield(_player.memory[RESTORED_SHIELDS])
	_player.memory.erase(RESTORED_SHIELDS)
	return false


func on_enemies_turn_end(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	if _player.health_comp.shield > 0:
		var shields : Array[float] = [0.1, 0.3, 0.5]
		_player.memory[RESTORED_SHIELDS] = ceili(_player.health_comp.shield * shields[_level - 1])
	return false

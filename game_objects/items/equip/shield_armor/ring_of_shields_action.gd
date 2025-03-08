class_name RingOfShields extends RefCounted


const SHIELDS_ON_BEGIN : StringName = "shields_on_begin"
const RESTORED_SHIELDS : StringName = "restored_shields_ring_of_shields"


func on_player_turn_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	if RESTORED_SHIELDS in _player.memory:
		_player.health_comp.add_shield(_player.memory[RESTORED_SHIELDS])
	_player.memory.erase(SHIELDS_ON_BEGIN)
	_player.memory.erase(RESTORED_SHIELDS)
	return false


func on_enemies_turn_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	_player.memory[SHIELDS_ON_BEGIN] = _player.health_comp.shield
	return false


func on_enemies_turn_end(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	if not (SHIELDS_ON_BEGIN in _player.memory):
		return false
	if _player.memory[SHIELDS_ON_BEGIN] > 0 and _player.health_comp.shield == 0:
		var shields : Array[int] = [10, 30, 50]
		_player.memory[RESTORED_SHIELDS] = shields[_level - 1]
	return false

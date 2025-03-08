class_name ShieldArmor extends RefCounted


const SHIELDS_ON_BEGIN : StringName = "shields_on_begin"
const RESTORED_SHIELDS : StringName = "restored_shields_shield_armor"


func on_player_turn_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	if RESTORED_SHIELDS in _player.memory:
		_player.health_comp.add_shield(_player.memory[RESTORED_SHIELDS])
	_player.memory.erase(SHIELDS_ON_BEGIN)
	_player.memory.erase(RESTORED_SHIELDS)
	return false


func on_enemies_turn_start(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	if _player.health_comp.shield > 0:
		_player.memory[SHIELDS_ON_BEGIN] = _player.health_comp.shield
	return false


func on_enemies_turn_end(args : Array[Variant]) -> bool:
	var _player := args[0] as Player
	var _level := args[1] as int
	if _player.health_comp.shield != 0:
		_player.memory[RESTORED_SHIELDS] = _player.health_comp.shield
	elif SHIELDS_ON_BEGIN in _player.memory:
		_player.memory[RESTORED_SHIELDS] = 100
	return false

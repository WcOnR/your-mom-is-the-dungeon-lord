class_name ShieldArmor extends ItemAction


const SHIELDS_ON_BEGIN : StringName = "shields_on_begin"
const RESTORED_SHIELDS : StringName = "restored_shields_shield_armor"


func on_player_turn_start(_player : Player, _level : int) -> void:
	if RESTORED_SHIELDS in _player.memory:
		_player.health_comp.add_shield(_player.memory[RESTORED_SHIELDS])
	_player.memory.erase(SHIELDS_ON_BEGIN)
	_player.memory.erase(RESTORED_SHIELDS)


func on_enemies_turn_start(_player : Player, _level : int) -> void:
	if _player.health_comp.shield > 0:
		_player.memory[SHIELDS_ON_BEGIN] = _player.health_comp.shield


func on_enemies_turn_end(_player : Player, _level : int) -> void:
	if _player.health_comp.shield != 0:
		_player.memory[RESTORED_SHIELDS] = _player.health_comp.shield
	elif SHIELDS_ON_BEGIN in _player.memory:
		_player.memory[RESTORED_SHIELDS] = 100

class_name VampireHeartAction extends RefCounted


func on_attack_applied(args : Array[Variant]) -> bool:
	var _player := args[2] as Player
	var persent : float = 0.1
	_player.health_comp.apply_heal(ceili(_player.health_comp.max_health * persent))
	return false


func on_battle_start(args : Array[Variant]) -> bool:
	var _from_type := args[0] as GemType
	var _to_type := args[1] as GemType
	var _player := args[2] as Player
	var _level := args[3] as int
	
	_to_type.actions.actions[0].args = [0, 20]
	
	var _field := _player.get_tree().get_first_node_in_group("Field") as Field
	var _gem_set := _field.gem_set.duplicate() as GemSet
	_gem_set.gem_types = _gem_set.replace_gem(_from_type, _to_type)
	_field.gem_set = _gem_set
	return false

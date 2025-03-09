class_name SharpHeartAction extends RefCounted


func on_battle_start(args : Array[Variant]) -> bool:
	var _from_type := args[0] as GemType
	var _to_type := args[1] as GemType
	var _player := args[2] as Player
	var _level := args[3] as int
	
	var tmp : Array[float] = [5, 0, 0]
	var base_heal : float = tmp[_level - 1]
	tmp = [5, 10, 15]
	var base_attack : float = tmp[_level - 1]
	_to_type.actions.actions[0].args = [base_heal, base_attack]
	
	var _field := _player.get_tree().get_first_node_in_group("Field") as Field
	var _gem_set := _field.gem_set.duplicate() as GemSet
	_gem_set.gem_types = _gem_set.replace_gem(_from_type, _to_type)
	_field.gem_set = _gem_set
	return false

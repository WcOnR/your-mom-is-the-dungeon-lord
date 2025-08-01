class_name SharpHeartAction extends ItemAction

@export var _from_type : GemType = null
@export var _to_type : GemType = null


func on_battle_start(_player : Player, _level : int) -> void:
	var tmp : Array[int] = [5, 0, 0]
	var base_heal : int = tmp[_level - 1]
	tmp = [5, 10, 15]
	var base_attack : int = tmp[_level - 1]
	var gem := _to_type.action as GemSharpHeart
	gem.base_attack = base_attack
	gem.base_heal = base_heal
	
	var _field := _player.get_tree().get_first_node_in_group("Field") as Field
	var _gem_set := _field.gem_set.duplicate() as GemSet
	_gem_set.gem_types = _gem_set.replace_gem(_from_type, _to_type)
	_field.gem_set = _gem_set

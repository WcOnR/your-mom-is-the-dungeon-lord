class_name VampireHeartAction extends ItemAction

@export var _from_type : GemType = null
@export var _to_type : GemType = null


func on_attack_applied(_player : Player, _level : int) -> void:
	var persent : float = 0.1
	_player.health_comp.apply_heal(ceili(_player.health_comp.max_health * persent))


func on_battle_start(_player : Player, _level : int) -> void:
	var gem := _to_type.action as GemSharpHeart
	gem.base_attack = 20
	gem.base_heal = 0
	var _field := _player.get_tree().get_first_node_in_group("Field") as Field
	var _gem_set := _field.gem_set.duplicate() as GemSet
	_gem_set.gem_types = _gem_set.replace_gem(_from_type, _to_type)
	_field.gem_set = _gem_set

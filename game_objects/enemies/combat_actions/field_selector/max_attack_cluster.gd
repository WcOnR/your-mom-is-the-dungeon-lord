class_name MaxAttackCluster extends FieldSelector

const GEM_TYPE : GemType = preload("res://game_objects/gems/attack_type.tres")


func get_target_ids(field : Field) -> Array[Vector2i]:
	var cluster := field.get_max_gem_cluster_by_type(GEM_TYPE)
	return [cluster.pick_random()]

class_name HasNotAllAllies extends Condition


func is_valid(enemy : Enemy) -> bool:
	var holder := enemy.get_tree().get_first_node_in_group("LineHolder") as LineHolder
	return holder.get_front_enemy_health_comp().size() != 3

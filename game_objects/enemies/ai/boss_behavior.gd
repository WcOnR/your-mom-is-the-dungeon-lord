class_name BossBehavior extends Behavior


const IS_VALID : StringName = "is_valid"
@export var conditions : Array[Condition] = []
@export var special_action : BattleAction = null


func get_next_action(enemy : Enemy) -> BattleAction:
	var valid_actions : Array[BattleAction] = []
	if _get_allies_count(enemy) <= randi_range(1, 2):
		return special_action
	for i in conditions.size():
		if conditions[i].is_valid(enemy):
			valid_actions.append(enemy.enemy_data.actions[i])
	return valid_actions.pick_random()


func _get_allies_count(enemy : Enemy) -> int:
	var holder := enemy.get_tree().get_first_node_in_group("LineHolder") as LineHolder
	return holder.get_front_enemy_health_comp().size()

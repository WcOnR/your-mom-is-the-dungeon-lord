class_name BossBehavior extends Behavior


const IS_VALID : StringName = "is_valid"
@export var conditions : Array[Condition] = []


func get_next_action(enemy : Enemy) -> Action:
	var valid_actions : Array[Action] = []
	for i in conditions.size():
		if conditions[i].is_valid(enemy):
			valid_actions.append(enemy.enemy_data.actions[i])
	return valid_actions.pick_random()

class_name RandomWeightBehavior extends Behavior

@export var weight : Array[int] = []

func get_next_action(enemy : Enemy) -> BattleAction:
	var actions := enemy.enemy_data.actions
	var sum_weight := 0
	for w in weight: 
		sum_weight += w
	var target := randi_range(0, sum_weight - 1)
	var i := 0
	var sum_it := 0
	while i < actions.size():
		sum_it += weight[i] as int
		if target < sum_it:
			break
		i += 1
	return actions[i]

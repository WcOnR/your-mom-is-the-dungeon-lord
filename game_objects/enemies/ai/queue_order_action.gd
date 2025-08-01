class_name QueueOrderAction extends Behavior

const LAST_QUEUE_IDX : StringName = "last_queue_idx"
@export var start_from_random_id := false


func get_next_action(enemy : Enemy) -> BattleAction:
	var i := 0
	if start_from_random_id:
		i = randi_range(0, enemy.enemy_data.actions.size() - 1)
	if LAST_QUEUE_IDX in enemy.memory:
		i = 1 + enemy.memory[LAST_QUEUE_IDX] as int
	i = i % enemy.enemy_data.actions.size()
	enemy.memory[LAST_QUEUE_IDX] = i
	return enemy.enemy_data.actions[i]

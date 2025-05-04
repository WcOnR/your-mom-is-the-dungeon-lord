class_name QueueOrderAction extends RefCounted

const LAST_QUEUE_IDX : StringName = "last_queue_idx"

func get_next_action(enemy : Enemy, _args : Array[Variant]) -> Action:
	var i := 0
	if not _args.is_empty() and _args[0] as bool:
		i = randi_range(0, enemy.enemy_data.actions.size() - 1)
	if LAST_QUEUE_IDX in enemy.memory:
		i = 1 + enemy.memory[LAST_QUEUE_IDX] as int
	i = i % enemy.enemy_data.actions.size()
	enemy.memory[LAST_QUEUE_IDX] = i
	return enemy.enemy_data.actions[i]

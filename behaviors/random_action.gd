class_name RandomAction extends RefCounted

func get_next_action(enemy : Enemy, _args : Array[Variant]) -> Action:
	return enemy.enemy_data.actions.pick_random() as Action

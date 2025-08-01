class_name RandomBehavior extends Behavior

func get_next_action(enemy : Enemy) -> BattleAction:
	return enemy.enemy_data.actions.pick_random() as BattleAction

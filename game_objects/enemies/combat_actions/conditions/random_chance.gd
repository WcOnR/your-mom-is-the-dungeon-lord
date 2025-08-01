class_name RandomChance extends Condition

@export var chance := 0.5

func is_valid(_enemy : Enemy) -> bool:
	return randf() < chance

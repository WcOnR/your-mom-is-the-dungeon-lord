class_name HPCondition extends Condition

enum Logic {LESS, LESS_EQ, GREATER, GREATER_EQ}
@export var op := Logic.LESS
@export var value := 100.0

func is_valid(enemy : Enemy) -> bool:
	match op:
		Logic.LESS:
			return enemy.health_comp.health < value
		Logic.LESS_EQ:
			return enemy.health_comp.health <= value
		Logic.GREATER:
			return enemy.health_comp.health > value
		Logic.GREATER_EQ:
			return enemy.health_comp.health >= value
	return false

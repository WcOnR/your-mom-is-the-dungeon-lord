class_name BattlePreset extends Resource

@export var line1 : Array[EnemyData]
@export var line2 : Array[EnemyData]
@export var line3 : Array[EnemyData]


func get_lines() -> Array:
	return [line1, line2, line3]

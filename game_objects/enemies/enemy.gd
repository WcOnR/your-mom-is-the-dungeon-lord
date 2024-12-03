class_name Enemy extends Node2D

@onready var health_comp : HealthComp = $HealthComp
var enemy_data : EnemyData = null
var next_action : Action = null

const ON_PLAN : StringName = "on_plan"
const ON_ACTION : StringName = "on_action"


func initialize(data : EnemyData) -> void:
	health_comp.health = data.max_health
	health_comp.max_health = data.max_health
	enemy_data = data
	$Icon.self_modulate = data.color


func plan_next_attack() -> void:
	next_action = enemy_data.actions.pick_random() as Action
	next_action.run(ON_PLAN)

func attack(player : Player):
	next_action.run(ON_ACTION, [enemy_data.damage, player])

class_name Enemy extends Node2D

@onready var health_comp : HealthComp = $HealthComp
@export var attack_anim_curve : Curve

var enemy_data : EnemyData = null
var next_action : Action = null
var anim : AnimObject = null

const ON_PLAN : StringName = "on_plan"
const ON_ACTION : StringName = "on_action"


func initialize(data : EnemyData) -> void:
	health_comp.health = data.max_health
	health_comp.max_health = data.max_health
	enemy_data = data
	$Icon.self_modulate = data.color


func plan_next_attack(line : BattleLine) -> void:
	next_action = enemy_data.actions.pick_random() as Action
	next_action.run(ON_PLAN, [enemy_data, line])


func _process(delta: float) -> void:
	if anim:
		anim.update(delta)


func attack(player : Player):
	anim = AnimObject.new()
	anim.initialize(self, attack_anim_curve, 0.25)
	await anim.anim_finished
	anim = null
	await next_action.run(ON_ACTION, [enemy_data, player])

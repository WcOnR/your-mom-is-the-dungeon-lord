class_name Enemy extends Node2D

@onready var health_comp : HealthComp = $HealthComp
@onready var attack_comp : AttackComp = $AttackComp
@export var attack_anim : Curve

var enemy_data : EnemyData = null
var next_action : Action = null
var breath_anim_obj : AnimObject = null

const ON_PLAN : StringName = "on_plan"
const ON_ACTION : StringName = "on_action"
const ON_DEATH : StringName = "on_death"
const ATTACK_ANIM_OFFSET : float = -50.0


func initialize(data : EnemyData) -> void:
	health_comp.health = data.max_health
	health_comp.max_health = data.max_health
	var player := get_tree().get_first_node_in_group("Player") as Player
	attack_comp.set_target(player.health_comp)
	if data.texture:
		$Icon.texture = data.texture
	enemy_data = data
	var sin_curve := AnimManagerSystem.get_curve("sin")
	breath_anim_obj = AnimObject.new(self, _breath_anim, sin_curve, 1.0)
	breath_anim_obj.set_loop(true, randf())
	breath_anim_obj.set_pause(true)
	AnimManagerSystem.start_anim(breath_anim_obj)


func set_in_shadow(in_shadow : bool) -> void:
	$Icon.self_modulate = Color.GRAY if in_shadow else Color.WHITE
	breath_anim_obj.set_pause(in_shadow)


func plan_next_attack(line : BattleLine) -> void:
	next_action = enemy_data.actions.pick_random() as Action
	next_action.run(ON_PLAN, [enemy_data, line])


func attack(player : Player):
	var anim := AnimObject.new(self, _attack_anim, attack_anim, 0.4)
	AnimManagerSystem.start_anim(anim)
	await anim.anim_finished
	await next_action.run(ON_ACTION, [self, player])


func clear_actions() -> void:
	next_action.run(ON_DEATH, [self])


func _attack_anim(t : float) -> void:
	$Icon.position.y = t * ATTACK_ANIM_OFFSET


func _breath_anim(t : float) -> void:
	$Icon.scale.y = 1.0 - (t - 0.5) * 0.02

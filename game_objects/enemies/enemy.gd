class_name Enemy extends Node2D

@onready var health_comp : HealthComp = $HealthComp
@onready var attack_comp : AttackComp = $AttackComp
@export var attack_anim : Curve

var enemy_data : EnemyData = null
var next_action : Action = null
var breath_anim_obj : AnimObject = null
var memory : Dictionary = {}
var _paralyze := false
var _invalid := false

const ON_PLAN : StringName = "on_plan"
const ON_PRE_ACTION : StringName = "on_pre_action"
const ON_ACTION : StringName = "on_action"
const ON_DEATH : StringName = "on_death"
const ATTACK_ANIM_OFFSET : float = -150.0
const ICON : Texture2D = preload("res://ui/action_icons/disoriented.png")


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
	$Icon.self_modulate = Color.DIM_GRAY if in_shadow else Color.WHITE
	breath_anim_obj.set_pause(in_shadow)


func set_paralyze() -> void:
	_paralyze = true


func plan_next_attack(line : BattleLine) -> void:
	if is_invalid():
		return
	if _paralyze:
		line.set_action(0, ICON, true)
	else:
		next_action = enemy_data.behavior.get_next_action(self)
		next_action.run(ON_PLAN, [self, line])


func attack(player : Player):
	if _paralyze:
		_paralyze = false
		return
	await next_action.run(ON_PRE_ACTION, [self, player])
	var anim := AnimObject.new(self, _attack_anim, attack_anim, 0.4)
	AnimManagerSystem.start_anim(anim)
	await anim.anim_finished
	await next_action.run(ON_ACTION, [self, player])


func on_destroy() -> void:
	_clear_actions()
	_invalid = true
	var anim := AnimObject.new(self, _destroy_anim, AnimManagerSystem.get_curve("easeIn"), 0.1)
	AnimManagerSystem.start_anim(anim)
	await anim.anim_finished


func is_invalid() -> bool:
	return _invalid


func _clear_actions() -> void:
	if next_action == null:
		return
	next_action.run(ON_DEATH, [self])


func _destroy_anim(t : float) -> void:
	$Icon.modulate = lerp(Color.WHITE, Color(Color.BLACK, 0.0), t)


func _attack_anim(t : float) -> void:
	$Icon.position.y = t * ATTACK_ANIM_OFFSET


func _breath_anim(t : float) -> void:
	$Icon.scale.y = 1.0 - (t - 0.5) * 0.02

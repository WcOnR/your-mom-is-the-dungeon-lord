class_name Enemy extends Node2D

@onready var health_comp : HealthComp = $HealthComp
@onready var attack_comp : AttackComp = $AttackComp
@onready var highlight : Node2D = %Highlight
@export var attack_anim : Curve
@export var attack_sound : AudioData = null


signal start_action


var enemy_data : EnemyData = null
var next_action : BattleAction = null
var breath_anim : Tween = null
var memory : Dictionary = {}
var _paralyze := false
var _invalid := false
var _id_anim_offset := 0.0
var _last_health := 0.0

const ATTACK_ANIM_OFFSET : float = -150.0
const ICON : Texture2D = preload("res://ui/action_icons/disoriented.png")


func initialize(data : EnemyData) -> void:
	health_comp.health = data.max_health
	health_comp.max_health = data.max_health
	_last_health = data.max_health
	health_comp.health_changed.connect(_health_changed)
	var player := get_tree().get_first_node_in_group("Player") as Player
	attack_comp.set_target(player.health_comp)
	if data.texture:
		$Icon.texture = data.texture
	enemy_data = data
	breath_anim = create_tween().set_loops()
	breath_anim.tween_method(_breath_anim, 0.0, TAU, 1.5)
	_id_anim_offset = randf_range(0.0, TAU)


func set_in_shadow(in_shadow : bool) -> void:
	$Icon.self_modulate = Color.DIM_GRAY if in_shadow else Color.WHITE
	if in_shadow:
		breath_anim.pause()
	else:
		breath_anim.play()


func set_paralyze() -> void:
	_paralyze = true


func plan_next_attack(line : BattleLine) -> void:
	if is_invalid():
		return
	if _paralyze:
		line.set_action(0, ICON, true)
	else:
		next_action = enemy_data.behavior.get_next_action(self)
		next_action.on_plan(self, line)


func attack(player : Player):
	if _paralyze or not next_action:
		_paralyze = false
		return
	await next_action.on_pre_action(self, player)
	start_action.emit()
	var tween := create_tween()
	tween.tween_method(_attack_anim, 0.0, 1.0, 0.4)
	SoundSystem.play_sound(attack_sound)
	await tween.finished
	var camera := get_tree().get_first_node_in_group("Camera") as GameCamera
	camera.screen_shake(5.0, 0.1)
	await next_action.on_action(self, player)


func on_destroy() -> void:
	_clear_actions()
	_invalid = true
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_method(_destroy_anim, 0.0, 1.0, 0.1)
	await tween.finished


func is_invalid() -> bool:
	return _invalid


func _clear_actions() -> void:
	if next_action == null:
		return
	next_action.on_death(self)


func _health_changed() -> void:
	if _last_health > health_comp.health:
		var tween := create_tween()
		tween.tween_property(highlight, "modulate:a", 0.75, 0.01)
		tween.parallel().tween_property($Icon, "scale:x", 0.9, 0.01)
		tween.tween_interval(0.19)
		tween.tween_property(highlight, "modulate:a", 0.0, 0.1)
		tween.parallel().tween_property($Icon, "scale:x", 1.0, 0.1)
		var camera := get_tree().get_first_node_in_group("Camera") as GameCamera
		var intencity := 10.0 if _last_health - health_comp.health > 75.0 else 5.0
		camera.screen_shake(intencity, 0.1)
		if enemy_data.hit_sound:
			SoundSystem.play_sound(enemy_data.hit_sound)
	_last_health = health_comp.health


func _destroy_anim(t : float) -> void:
	$Icon.modulate = lerp(Color.WHITE, Color(Color.BLACK, 0.0), t)


func _attack_anim(t : float) -> void:
	$Icon.position.y = attack_anim.sample(t) * ATTACK_ANIM_OFFSET


func _breath_anim(t : float) -> void:
	$Icon.scale.y = 1.0 - sin(t + _id_anim_offset) * 0.01

class_name HealthComp extends Node

@export var shield := 0
@export var health := 100
@export var max_health := 100

var _is_dead := false

signal health_changed
signal shield_changed
signal death


func add_shield(points : int) -> void:
	if _is_dead or points <= 0:
		return
	shield += points
	shield_changed.emit()


func apply_heal(heal : int) -> void:
	_set_health(health + heal)


func apply_damage(damage : int) -> void:
	var new_damage := _absorb_damage(damage)
	_set_health(health - new_damage)


func _absorb_damage(damage : int) -> int:
	var dif := damage - shield
	var old_shield := shield
	shield = max(-dif, 0)
	if old_shield != shield :
		shield_changed.emit()
	return max(dif, 0)


func _drop_shield() -> void:
	if shield > 0 :
		shield = 0
		shield_changed.emit()


func _set_health(new_health : int) -> void:
	if _is_dead or new_health == health or new_health == max_health:
		return
	health = min(max_health, new_health)
	health_changed.emit()
	if health <= 0:
		_is_dead = false
		death.emit()

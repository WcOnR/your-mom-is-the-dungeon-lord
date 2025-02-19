class_name Player extends Node

@onready var health_comp : HealthComp = $HealthComp
@onready var attack_comp : AttackComp = $AttackComp
@onready var inventory_comp : InventoryComp = $InventoryComp

var _enemy : Enemy = null


func set_enemy(enemy : Enemy) -> void:
	if enemy != _enemy:
		_enemy = enemy
		attack_comp.set_target(enemy.health_comp if enemy else null)

class_name Enemy extends Node2D

@onready var health_comp : HealthComp = $HealthComp
var damage : int = 0 

func initialize(data : EnemyData):
	health_comp.health = data.health
	health_comp.max_health = data.max_health
	damage = data.damage
	$Icon.self_modulate = data.color

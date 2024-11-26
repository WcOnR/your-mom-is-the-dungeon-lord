class_name BattleLine extends Area2D


@onready var target : Node2D = $Target
@onready var health_ui : HealthCompUI = $HealthLabel
@onready var enemy_scene : PackedScene = preload("res://game_objects/enemies/enemy.tscn")

signal enemy_dead

var enemies : Array[Enemy] = []


func set_enemies(data : Array[EnemyData]) -> void:
	var i := 0
	while i < data.size():
		var reverse := data.size() - i - 1
		var enemy := enemy_scene.instantiate() as Enemy
		add_child(enemy)
		enemies.insert(0, enemy)
		enemy.position.y = -reverse * 50
		enemy.scale *= 1 - (reverse * 0.05)
		enemy.initialize(data[-i-1])
		enemy.health_comp.death.connect(_on_enemy_death)
		i += 1
	_update_health_label()


func select(_select : bool) -> void:
	target.visible = _select


func _on_enemy_death() -> void:
	remove_child(enemies[0])
	enemies[0].queue_free()
	enemies.remove_at(0)
	var i := 0
	while i < enemies.size():
		enemies[i].position.y = -i * 50
		enemies[i].scale = Vector2.ONE * (1 - (i * 0.05))
		i += 1
	enemy_dead.emit()
	_update_health_label()


func _update_health_label() -> void:
	if enemies.is_empty():
		health_ui.visible = false
		return
	health_ui.visible = true
	health_ui.health_comp = enemies[0].get_node("HealthComp") as HealthComp
	health_ui.sync_comp()

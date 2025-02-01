class_name BattleLine extends Area2D


@onready var target : Node2D = $Target
@onready var health_ui : HealthCompUI = $HealthLabel
@onready var enemy_scene : PackedScene = preload("res://game_objects/enemies/enemy.tscn")

signal enemy_dead

const ENEMY_OFFSET_Y := 15.0
const ENEMY_OFFSET_X := 25.0
const ENEMY_OFFSET_SCALE := 0.1

var enemies : Array[Enemy] = []


func set_enemies(data : Array[EnemyData]) -> void:
	var enemy_data := data.duplicate()
	enemy_data.reverse()
	for e in enemy_data: 
		var enemy := enemy_scene.instantiate() as Enemy
		add_child(enemy)
		enemies.insert(0, enemy)
		enemy.initialize(e)
		enemy.health_comp.death.connect(_on_enemy_death)
	
	var i := 0
	for enemy in enemies:
		enemy.position.x = _get_enemy_offset_x(i)
		enemy.position.y = _get_enemy_offset_y(i)
		enemy.scale = _get_enemy_offset_scale(i)
		enemy.set_in_shadow(i != 0)
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
		if i == 0:
			enemies[i].position.x = 0
		enemies[i].position.y = _get_enemy_offset_y(i)
		enemies[i].scale = _get_enemy_offset_scale(i)
		enemies[i].set_in_shadow(i != 0)
		i += 1
	enemy_dead.emit()
	_update_health_label()


func _get_enemy_offset_x(i : int) -> float:
	match i:
		1:
			return ENEMY_OFFSET_X
		2:
			return -ENEMY_OFFSET_X
	return 0


func _get_enemy_offset_y(i : int) -> float:
	return -i * ENEMY_OFFSET_Y


func _get_enemy_offset_scale(i : int) -> Vector2:
	return Vector2.ONE * (1 - (i * ENEMY_OFFSET_SCALE))


func _update_health_label() -> void:
	if enemies.is_empty():
		health_ui.visible = false
		return
	health_ui.visible = true
	health_ui.health_comp = enemies[0].get_node("HealthComp") as HealthComp
	health_ui.sync_comp()


func set_action(value : int, img : Texture2D, force : bool = false) -> void:
	health_ui.set_action(value, img, force)

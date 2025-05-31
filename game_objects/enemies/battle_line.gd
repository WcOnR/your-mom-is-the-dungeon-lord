class_name BattleLine extends Area2D


@onready var target : Node2D = $Target
@onready var health_ui : EnemyHealthComp = $HealthComp
@onready var line_color : TextureRect = $LineColor
@onready var enemy_scene : PackedScene = preload("res://game_objects/enemies/enemy.tscn")

signal enemy_dead

const ENEMY_OFFSET_Y := 65.0
const ENEMY_OFFSET_X := 55.0
const ENEMY_OFFSET_SCALE := 0.12

var enemies : Array[Enemy] = []
var _move_in_front_anims : Array[Tween] = []
var _id : int = -1


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
		enemy.z_index = -i
		i += 1
	_update_health_label()


func select(_select : bool) -> void:
	target.visible = _select


func set_id(id : int) -> void:
	_id = id
	$LineColor.modulate = SettingsManager.get_settings().line_colors[id]


func get_id() -> int:
	return _id


func _on_enemy_death() -> void:
	await _remove_front_enemy()
	for t in _move_in_front_anims:
		t.kill()
	_move_in_front_anims.clear()
	var i := 0
	while i < enemies.size():
		var enemy := enemies[i]
		var pos := enemy.position
		if i == 0:
			pos.x = 0
		pos.y = _get_enemy_offset_y(i)
		var params := [enemy, enemy.position, enemy.scale, pos, _get_enemy_offset_scale(i)]
		var tween := enemy.create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_interval(i * 0.25)
		tween.tween_method(_move_in_front.bindv(params), 0.0, 1.0, 0.25)
		_move_in_front_anims.append(tween)
		enemy.set_in_shadow(i != 0)
		i += 1
	enemy_dead.emit()
	_update_health_label()


func _remove_front_enemy() -> void:
	var tmp_enemy := enemies[0]
	await tmp_enemy.on_destroy()
	remove_child(tmp_enemy)
	tmp_enemy.queue_free()
	enemies.remove_at(0)
	var i := 0
	for enemy in enemies:
		enemy.z_index = -i
		i += 1


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


func _move_in_front(t : float, enemy : Enemy, f_p : Vector2, f_s : Vector2, t_p : Vector2, t_s : Vector2) -> void:
	enemy.scale = lerp(f_s, t_s, t)
	enemy.position = lerp(f_p, t_p, t)


func _update_health_label() -> void:
	if enemies.is_empty():
		health_ui.visible = false
		line_color.visible = false
		return
	health_ui.visible = true
	line_color.visible = true
	health_ui.set_health_comp(enemies[0].get_node("HealthComp"))


func set_action(value : int, img : Texture2D, force : bool = false) -> void:
	health_ui.set_action(value, img, force)

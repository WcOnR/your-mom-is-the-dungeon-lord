class_name BattleLine extends Area2D


@onready var target : Node2D = $Target
@onready var health_ui : HealthCompUI = $HealthLabel
@onready var line_color : TextureRect = $LineColor
@onready var enemy_scene : PackedScene = preload("res://game_objects/enemies/enemy.tscn")

signal enemy_dead

const ENEMY_OFFSET_Y := 15.0
const ENEMY_OFFSET_X := 25.0
const ENEMY_OFFSET_SCALE := 0.12

var enemies : Array[Enemy] = []
var _move_in_front_anims : Array[AnimObject] = []
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
		i += 1
	_update_health_label()


func select(_select : bool) -> void:
	target.visible = _select


func set_id(id : int) -> void:
	_id = id
	$LineColor.modulate = SettingsManager.settings.line_colors[id]


func get_id() -> int:
	return _id


func _on_enemy_death() -> void:
	_remove_front_enemy()
	for a in _move_in_front_anims:
		AnimManagerSystem.drop_anim(a)
	_move_in_front_anims.clear()
	var anim_curve := AnimManagerSystem.get_curve("easeInOut")
	var i := 0
	while i < enemies.size():
		var enemy := enemies[i]
		var pos := enemy.position
		if i == 0:
			pos.x = 0
		pos.y = _get_enemy_offset_y(i)
		var params := [enemy, enemy.position, enemy.scale, pos, _get_enemy_offset_scale(i)]
		var anim := AnimObject.new(enemy, _move_in_front.bindv(params), anim_curve, 0.25)
		_move_in_front_anims.append(anim)
		enemy.set_in_shadow(i != 0)
		i += 1
	AnimManagerSystem.start_anim_queue(_move_in_front_anims)
	enemy_dead.emit()
	_update_health_label()


func _remove_front_enemy() -> void:
	var tmp_enemy := enemies[0]
	tmp_enemy.clear_actions()
	remove_child(tmp_enemy)
	tmp_enemy.queue_free()
	enemies.remove_at(0)


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
	health_ui.health_comp = enemies[0].get_node("HealthComp") as HealthComp
	health_ui.sync_comp()


func set_action(value : int, img : Texture2D, force : bool = false) -> void:
	health_ui.set_action(value, img, force)

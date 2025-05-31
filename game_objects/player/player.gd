class_name Player extends Node

@export var debug_equid : Array[ItemPreset] = []

@onready var health_comp : HealthComp = $HealthComp
@onready var attack_comp : AttackComp = $AttackComp
@onready var inventory_comp : InventoryComp = $InventoryComp
@onready var equipment_manager_comp : EquipmentManagerComp = $EquipmentManagerComp

var memory : Dictionary = {}
var shop_level : int = 1
var _enemy : Enemy = null
var _last_health := 0.0


func _ready() -> void:
	#get_tree().create_timer(0.1).timeout.connect(_debug_equid)
	health_comp.health_changed.connect(_on_health_changed)
	_last_health = health_comp.health


func set_enemy(enemy : Enemy) -> void:
	if enemy != _enemy:
		_enemy = enemy
		attack_comp.set_target(enemy.health_comp if enemy else null)


func _on_health_changed() -> void:
	if _last_health > health_comp.health:
		var camera := get_tree().get_first_node_in_group("Camera") as GameCamera
		var intencity := 20.0 if _last_health - health_comp.health > 75.0 else 10.0
		camera.screen_shake(intencity, 0.1)
		camera.play_hit_anim()
	_last_health = health_comp.health


func _debug_equid() -> void:
	for item in debug_equid:
		inventory_comp.add_item(item)
	var currency_pack := inventory_comp.get_currency_pack()
	currency_pack.count = 10000
	inventory_comp.add_pack(currency_pack)

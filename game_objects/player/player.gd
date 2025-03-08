class_name Player extends Node

@export var debug_equid : Array[ItemPreset] = []

@onready var health_comp : HealthComp = $HealthComp
@onready var attack_comp : AttackComp = $AttackComp
@onready var inventory_comp : InventoryComp = $InventoryComp
@onready var equipment_manager_comp : EquipmentManagerComp = $EquipmentManagerComp

var memory : Dictionary = {}
var _enemy : Enemy = null


func _ready() -> void:
	#get_tree().create_timer(0.1).timeout.connect(_debug_equid)
	pass


func set_enemy(enemy : Enemy) -> void:
	if enemy != _enemy:
		_enemy = enemy
		attack_comp.set_target(enemy.health_comp if enemy else null)


func _debug_equid() -> void:
	for item in debug_equid:
		inventory_comp.add_item(item)
	var currency_pack := inventory_comp.get_currency_pack()
	currency_pack.count = 10000
	inventory_comp.add_pack(currency_pack)

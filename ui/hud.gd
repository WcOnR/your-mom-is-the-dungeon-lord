class_name HUD extends Control

@export var player : NodePath 

@onready var health_ui : HealthUI = $Panel/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/HealthUi

var _player : Player = null
var _health_comp : HealthComp = null


func _ready() -> void:
	_player = get_node(player) as Player
	_health_comp = _player.get_node("HealthComp") as HealthComp
	health_ui.set_health_comp(_health_comp)


func _on_health_changed():
	health_ui.set_health(_health_comp.health)

class_name HealthCompUI extends Container

@export var health_comp : HealthComp

@onready var health_label : Label = %HealthLabel
@onready var damage_progress : ProgressBar = %DamageProgressBar
@onready var health_progress : ProgressBar = %HealthProgressBar

@onready var shields : ActionUI = %shields

const HEALTH_FORMAT := "%d/%d"

var _health : int = 0


func _ready() -> void:
	if health_comp:
		sync_comp()


func sync_comp() -> void:
	_health = health_comp.health
	_on_health_changed()
	health_comp.health_changed.connect(_on_health_changed)
	_on_shield_changed()
	health_comp.shield_changed.connect(_on_shield_changed)


func _on_health_changed() -> void:
	_health = health_comp.health
	health_label.text = HEALTH_FORMAT % [_health, health_comp.max_health]
	damage_progress.max_value = health_comp.max_health
	health_progress.max_value = health_comp.max_health
	if health_progress.value < _health:
		damage_progress.value = _health
		create_tween().tween_property(health_progress, "value", _health, 0.1)
	else:
		health_progress.value = _health
		create_tween().tween_property(damage_progress, "value", _health, 0.1)


func _on_shield_changed(_hidden : bool = true) -> void:
	shields.set_value(health_comp.shield)

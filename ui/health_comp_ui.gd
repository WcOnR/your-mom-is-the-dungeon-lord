class_name HealthCompUI extends Label

@export var health_comp : HealthComp

const HEALTH_FORMAT := "%d/%d"


func _ready() -> void:
	if health_comp:
		sync_comp()


func sync_comp() -> void:
	_on_health_changed()
	health_comp.health_changed.connect(_on_health_changed)


func _on_health_changed() -> void:
	text = HEALTH_FORMAT % [health_comp.health, health_comp.max_health]

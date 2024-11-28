class_name HealthCompUI extends Container

@export var health_comp : HealthComp

@onready var health_label : Label = $Container/HealthProgressBar/HealthLabel
@onready var health_progress : ProgressBar = $Container/HealthProgressBar

@onready var shield_img : TextureRect = $MarginContainer/ShieldImg
@onready var shield_label : Label = $MarginContainer/ShieldImg/ShieldLabel

const HEALTH_FORMAT := "%d/%d"


func _ready() -> void:
	if health_comp:
		sync_comp()


func sync_comp() -> void:
	_on_health_changed()
	health_comp.health_changed.connect(_on_health_changed)
	_on_shield_changed()
	health_comp.shield_changed.connect(_on_shield_changed)


func _on_health_changed() -> void:
	health_label.text = HEALTH_FORMAT % [health_comp.health, health_comp.max_health]
	health_progress.max_value = health_comp.max_health
	health_progress.value = health_comp.health


func _on_shield_changed() -> void:
	shield_img.visible = health_comp.shield > 0
	shield_label.text = str(health_comp.shield)

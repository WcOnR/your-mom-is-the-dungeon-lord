class_name HealthCompUI extends Container

@export var health_comp : HealthComp

@onready var health_label : Label = $Container2/MarginContainer/Container/HBoxContainer/HealthProgressBar/HealthLabel
@onready var health_progress : ProgressBar = $Container2/MarginContainer/Container/HBoxContainer/HealthProgressBar

@onready var shields : ActionUI = $Container2/MarginContainer/shields
@onready var action_ui : ActionUI = $Container2/MarginContainer2/ActionUi

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


func set_action(value : int, img : Texture2D, force : bool = false) -> void:
	action_ui.show_img_with_zero = force
	action_ui.set_value(value)
	action_ui.set_img(img)


func _on_health_changed() -> void:
	var dif := health_comp.health - _health
	if dif != 0:
		PopUpNumber.create_pop_up(health_progress, dif, health_progress.size/2.0)
	_health = health_comp.health
	health_label.text = HEALTH_FORMAT % [_health, health_comp.max_health]
	health_progress.max_value = health_comp.max_health
	health_progress.value = _health


func _on_shield_changed() -> void:
	var dif := health_comp.shield - shields.get_value()
	if dif != 0:
		var pos := shields.position + shields.size / 2.0
		PopUpNumber.create_pop_up(self, dif, pos)
	shields.set_value(health_comp.shield)

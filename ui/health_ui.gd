class_name HealthUI extends PanelContainer


@onready var health_label : HealthCompUI = $HBoxContainer_right/HealthLabel


func set_health_comp(health_comp : HealthComp) -> void:
	health_label.health_comp = health_comp
	health_label.sync_comp()

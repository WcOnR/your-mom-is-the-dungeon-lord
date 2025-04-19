class_name EnemyHealthComp extends MarginContainer

@onready var action_ui : ActionUI = %ActionUi


func set_health_comp(_health_comp : HealthComp) -> void:
	%HealthComp.health_comp = _health_comp
	%HealthComp.sync_comp()


func set_action(value : int, img : Texture2D, force : bool = false) -> void:
	action_ui.show_img_with_zero = force
	action_ui.set_value(value)
	action_ui.set_img(img)

class_name WinScene extends Node2D



func _ready() -> void:
	%UIHolder.modulate = Color(Color.WHITE, 0.0)
	get_tree().create_timer(1).timeout.connect(_on_show_ui, ConnectFlags.CONNECT_ONE_SHOT)


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_show_ui() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(%UIHolder, "modulate", Color(Color.WHITE, 1.0), 1.5)
	await get_tree().create_timer(3).timeout
	%ReloadButton.modulate = Color(Color.WHITE, 0.0)
	%ReloadButton.visible = true
	tween = get_tree().create_tween()
	tween.tween_property(%ReloadButton, "modulate", Color(Color.WHITE, 1.0), 1.5)

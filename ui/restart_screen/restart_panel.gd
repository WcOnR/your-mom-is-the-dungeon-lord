class_name RestartPanel extends Control


func end_game() -> void:
	%Label1.modulate = Color(Color.WHITE, 0.0)
	%Label2.modulate = Color(Color.WHITE, 0.0)
	%ResetBtn.modulate = Color(Color.WHITE, 0.0)
	await get_tree().create_timer(1.5).timeout
	var tween := get_tree().create_tween()
	tween.tween_property(%Label1, "modulate", Color(Color.WHITE, 1.0), 1.5)
	await get_tree().create_timer(2.0).timeout
	tween = get_tree().create_tween()
	tween.tween_property(%Label2, "modulate", Color(Color.WHITE, 1.0), 1.5)
	await get_tree().create_timer(2.0).timeout
	tween = get_tree().create_tween()
	tween.tween_property(%ResetBtn, "modulate", Color(Color.WHITE, 1.0), 1.5)


func _on_button_pressed() -> void:
	%ResetBtn.disabled = true
	var world := SceneLoaderSystem.get_world()
	await world.fade_in()
	get_tree().reload_current_scene()

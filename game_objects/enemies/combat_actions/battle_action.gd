class_name BattleAction extends Resource


func on_plan(_enemy : Enemy, _line : BattleLine) -> void:
	assert(false)


func on_pre_action(enemy : Enemy, _player : Player) -> void:
	await enemy.get_tree().process_frame	# Just to avoid await warning
	pass


func on_action(enemy : Enemy, _player : Player) -> void:
	assert(false)
	await enemy.get_tree().process_frame	# Just to avoid await warning


func on_death(_enemy : Enemy) -> void:
	pass

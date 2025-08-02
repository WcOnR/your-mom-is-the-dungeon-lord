class_name BossBattleGameMode extends BattleGameMode


func _connect_battle_end() -> void:
	for l in _line_holder.lines:
		for enemy in l.enemies:
			if enemy.enemy_data.is_boss:
				enemy.health_comp.death.connect(_battle_end.bind(true))


func _disconnect_battle_end() -> void:
	for l in _line_holder.lines:
		for enemy in l.enemies:
			if enemy.enemy_data.is_boss:
				enemy.health_comp.death.disconnect(_battle_end)

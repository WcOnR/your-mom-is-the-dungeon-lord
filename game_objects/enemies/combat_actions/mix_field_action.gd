class_name MixFieldAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/mix.png")

@export var shuffle : Shuffle = null


func on_plan(_enemy : Enemy, line : BattleLine) -> void:
	line.set_action(0, ICON, true)


func on_pre_action(enemy : Enemy, _player : Player) -> void:
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle


func on_action(_enemy : Enemy, player : Player) -> void:
	var game_mode := player.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	var map : Dictionary = shuffle.get_move_ids(field)
	await game_mode._field.grid.reshuffle(map)

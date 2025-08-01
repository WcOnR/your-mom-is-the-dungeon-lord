class_name DirtAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/dirt.png")
const ARGS_BEGIN : int = 1

@export var selector : FieldSelector = null


func on_plan(_enemy : Enemy, line : BattleLine) -> void:
	line.set_action(0, ICON, true)


func on_pre_action(enemy : Enemy, _player : Player) -> void:
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle


func on_action(enemy : Enemy, _player : Player) -> void:
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	var cell_ids : Array[Vector2i] = selector.get_target_ids(field)
	for cell_id in cell_ids:
		field.show_icon(cell_id, CellIcons.Type.DIRT, true, -1)

class_name DirtPositionAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/dirt.png")
const FIELD_TARGET : StringName = "field_dirt_target"
const LINE_ID : StringName = "line_id"
const GET_TARGET_IDS : StringName = "get_target_ids"
const ARGS_BEGIN : int = 1


func on_plan(args : Array[Variant]) -> void:
	var line : BattleLine = args[ARGS_BEGIN + 1] as BattleLine
	line.set_action(0, ICON, true)


func on_pre_action(args : Array[Variant]) -> void:
	var enemy : Enemy = args[ARGS_BEGIN] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	if not field.grid.is_idle():
		await field.grid.grid_idle


func on_action(args : Array[Variant]) -> void:
	var script_object = (args[0] as GDScript).new()
	var callable = Callable(script_object, GET_TARGET_IDS)
	var enemy : Enemy = args[ARGS_BEGIN] as Enemy
	var game_mode := enemy.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	var cell_ids : Array[Vector2i] = callable.call(field)
	for cell_id in cell_ids:
		field.show_icon(cell_id, CellIcons.Type.DIRT, true, -1)

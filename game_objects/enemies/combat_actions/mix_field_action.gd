class_name MixFieldAction extends RefCounted

const ICON : Texture2D = preload("res://ui/action_icons/mix.png")

const GET_MOVE_IDS : StringName = "get_move_ids"
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
	var callable = Callable(script_object, GET_MOVE_IDS)
	var player : Player = args[ARGS_BEGIN + 1] as Player
	var game_mode := player.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	var field := game_mode._field
	var map : Dictionary = callable.call(field)
	await game_mode._field.grid.reshuffle(map)

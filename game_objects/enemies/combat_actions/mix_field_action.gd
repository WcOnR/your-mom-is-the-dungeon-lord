class_name MixFieldAction extends RefCounted

const ICON : Texture2D = preload("res://game_objects/enemies/combat_actions/mix.png")


func on_plan(args : Array[Variant]) -> bool:
	var line : BattleLine = args[1] as BattleLine
	line.set_action(0, ICON, true)
	return false


func on_action(args : Array[Variant]) -> bool:
	var player : Player = args[1] as Player
	var game_mode := player.get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	game_mode._field.reshuffle()
	return false

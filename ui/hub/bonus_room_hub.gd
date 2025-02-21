class_name BonusRoomHub extends Control

@export var game_mode : NodePath
@export var bonus : NodePath

var _game_mode : BonusGameMode = null
var _bonus : PickUpBonus = null


func _ready() -> void:
	_game_mode = get_node(game_mode)
	_bonus = get_node(bonus)
	_bonus.picked_up.connect(_on_pick_up)
	$BonusPickUpPanel.collected.connect(_on_collected)


func _on_pick_up() -> void:
	$BonusPickUpPanel.set_reward_view(_game_mode.get_rewards())
	$BonusPickUpPanel.visible = true


func _on_collected() -> void:
	_game_mode.finish_room()

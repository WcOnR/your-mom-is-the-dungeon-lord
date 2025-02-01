extends Control

@export var game_mode : NodePath
@onready var label : Label = $Panel/VBoxContainer/WinLabel

var _game_mode : BattleGameMode = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_game_mode = get_node(game_mode) as BattleGameMode
	_game_mode.state_changed.connect(_on_game_ends)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_game_ends() -> void:
	var _win := _game_mode.is_state(BattleGameMode.State.WIN)
	var _lost := _game_mode.is_state(BattleGameMode.State.LOST)
	if _win or _lost:
		visible = true
		label.text = "YOU WIN!" if _win else "YOU LOST!"


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

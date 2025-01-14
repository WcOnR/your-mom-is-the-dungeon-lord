extends Control

@export var game_mode : NodePath
@onready var label : Label = $Panel/VBoxContainer/WinLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gm := get_node(game_mode) as BattleGameMode
	gm.game_ends.connect(_on_game_ends)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_game_ends(_win : bool) -> void:
	visible = true
	label.text = "YOU WIN!" if _win else "YOU LOST!"


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

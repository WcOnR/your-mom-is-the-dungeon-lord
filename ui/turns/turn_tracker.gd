class_name TurnTracker extends Control


@export var normal : Texture2D
@export var disabled : Texture2D
@export var broken : Texture2D

@onready var rect_holder : Container = $HBoxContainer

var rects : Array[TextureRect] = []

func _ready() -> void:
	for c in rect_holder.get_children():
		rects.append(c as TextureRect)


func update_state(game_mode : BattleGameMode) -> void:
	var l := game_mode.turns_left()
	var m := game_mode.get_max_turns()
	for i in rects.size():
		if i < l:
			rects[i].texture = normal
		elif i < m:
			rects[i].texture = disabled
		else:
			rects[i].texture = broken

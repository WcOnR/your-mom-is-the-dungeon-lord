class_name TurnTracker extends Control


var rects : Array[NinePatchRect] = []

const HEALTH_FORMAT := "%d/%d"


func _ready() -> void:
	for c in %BatteryCellHolder.get_children():
		rects.append(c as NinePatchRect)


func update_state(game_mode : BattleGameMode) -> void:
	var l := game_mode.turns_left()
	var m := game_mode.get_max_turns()
	%BatteryInfo.text = HEALTH_FORMAT % [l, m]
	for i in rects.size():
		if i < l:
			rects[i].visible = true
			rects[i].modulate.a = 1.0
		elif i < m:
			rects[i].visible = true
			rects[i].modulate.a = 0.0
		else:
			rects[i].visible = false

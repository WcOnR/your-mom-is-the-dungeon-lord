class_name TurnTracker extends Control


var rects : Array[NinePatchRect] = []
var _left : int = 5
var _max : int = 5 

const HEALTH_FORMAT := "%d/%d"


func _ready() -> void:
	for c in %BatteryCellHolder.get_children():
		rects.append(c as NinePatchRect)


func update_state(game_mode : BattleGameMode) -> void:
	var l := game_mode.turns_left()
	var m := game_mode.get_max_turns()
	%BatteryInfo.text = HEALTH_FORMAT % [l, m]
	for i in rects.size():
		if i >= m and i < _max:
			rects[i].visible = false
		elif i < m:
			if l > _left and i >= _left:
				rects[i].visible = true
				rects[i].create_tween().tween_property(rects[i],"modulate:a", 1.0, 0.3)
			elif l < _left and i >= l:
				rects[i].visible = true
				rects[i].create_tween().tween_property(rects[i],"modulate:a", 0.0, 0.3)
	if _max != m:
		var tween := create_tween()
		tween.tween_property(self, "modulate:a", 0.75, 0.1)
		tween.tween_property(self, "modulate:a", 1.0, 0.3)
	_left = l
	_max = m


func _foo(_t : float) -> void:
	%BatteryCellHolder.visible = false
	%BatteryCellHolder.visible = true

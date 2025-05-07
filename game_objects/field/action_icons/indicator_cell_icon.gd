class_name IndicatorCellIcon extends Node2D

@export var icons : Array[Texture2D] = []

@onready var indicators : Array[Sprite2D] = [$Indicator1, $Indicator2, $Indicator3]


func set_lines(lines : Array) -> void:
	var settings := SettingsManager.get_settings()
	for i in indicators.size():
		indicators[i].visible = i < lines.size()
		if i < lines.size():
			indicators[i].texture = icons[i + _get_icon_offset(lines.size())]
			indicators[i].modulate = Color(settings.line_colors[lines[i]], 0.5)


func _get_icon_offset(line_count : int) -> int:
	var offset := 0 
	while line_count > 0:
		line_count -= 1
		offset += line_count
	return offset

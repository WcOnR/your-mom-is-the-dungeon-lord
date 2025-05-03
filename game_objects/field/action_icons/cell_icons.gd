class_name CellIcons extends Node2D

@onready var _icons : Array[Sprite2D] = [$Aim, $CellAttack, $CellClear]
@onready var _line_id : Array[Sprite2D] = [$LineIndefier1, $LineIndefier2, $LineIndefier3]

enum Type {AIM, ATTACK, CLEAR}

var _shown_lines : Dictionary = {}

func set_icon_visibility(type : CellIcons.Type, _show : bool, line : int) -> void:
	if _show:
		_shown_lines[line] = type
	else:
		_shown_lines.erase(line)
	_update_lines()


func clean_icons() -> void:
	for i in _icons:
		i.visible = false
	for l in _line_id:
		l.visible = false
	_shown_lines.clear()


func emit_smoke_fx() -> void:
	$SmokeParticles2D.emitting = true


func _update_lines() -> void:
	for i in _icons:
		i.visible = false
	var count := _shown_lines.keys().size()
	var i := 0
	while i < _line_id.size():
		_line_id[i].visible = i < count
		if i < count:
			var id : int = _shown_lines.keys()[i]
			_line_id[i].modulate = SettingsManager.get_settings().line_colors[id]
			_icons[int(_shown_lines[id])].visible = true
		i += 1

class_name CellIcons extends Node2D

@onready var _icons : Array[Sprite2D] = [$Aim, $CellAttack, $CellClear, $Dirt]
@onready var _line_id : Array[Sprite2D] = [$LineIndefier1, $LineIndefier2, $LineIndefier3]

enum Type {AIM, ATTACK, CLEAR, DIRT}
const INVALID_ID := -1

var _shown_lines : Dictionary = {}

func set_icon_visibility(type : CellIcons.Type, _show : bool, line : int) -> void:
	if _show:
		_shown_lines[line] = type
	else:
		_shown_lines.erase(line)
	_update_lines()


func is_icon_type(icon_type : CellIcons.Type) -> bool:
	for line in _shown_lines:
		if _shown_lines[line] == icon_type:
			return true
	return false


func clean_icons() -> void:
	var lines := _shown_lines.keys().duplicate()
	if INVALID_ID in lines:
		lines.erase(INVALID_ID)
	for line in lines:
		_shown_lines.erase(line)
	_update_lines()


func clean_effects() -> void:
	_shown_lines.erase(INVALID_ID)
	_update_lines()


func emit_smoke_fx() -> void:
	$SmokeParticles2D.emitting = true


func _update_lines() -> void:
	for i in _icons:
		i.visible = false
	var lines := _shown_lines.keys().duplicate()
	if INVALID_ID in lines:
		_icons[INVALID_ID].visible = true
		lines.erase(INVALID_ID)
	var count := lines.size()
	var i := 0
	while i < _line_id.size():
		_line_id[i].visible = i < count
		if i < count:
			var id : int = lines[i]
			_line_id[i].modulate = SettingsManager.get_settings().line_colors[id]
			_icons[int(_shown_lines[id])].visible = true
		i += 1

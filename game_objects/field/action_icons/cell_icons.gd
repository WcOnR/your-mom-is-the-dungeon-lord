class_name CellIcons extends Node2D

@onready var _indicators : Array[IndicatorCellIcon] = [$AimIndicatorCellIcon, $AreaIndicatorCellIcon, $ClearIndicatorCellIcon]
@onready var _effects : Array[Sprite2D] = [$Dirt]

enum Type {AIM, ATTACK, CLEAR, DIRT}
const INVALID_ID := -1
const FIRST_EFFECT_INDEX := 3

var _shown_lines : Dictionary = {}


func set_icon_visibility(type : CellIcons.Type, _show : bool, line : int) -> void:
	if _show:
		if not type in _shown_lines:
			_shown_lines[type] = {}
		_shown_lines[type][line] = null
	else:
		if type in _shown_lines:
			_shown_lines[type].erase(line)
	_update_lines()


func is_icon_type(icon_type : CellIcons.Type) -> bool:
	return icon_type in _shown_lines and not _shown_lines[icon_type].is_empty()


func clean_icons() -> void:
	var effects := _get_all_effects_type()
	for type in _shown_lines:
		if not type in effects:
			_shown_lines[type] = {}
	_update_lines()


func clean_effects() -> void:
	var effects := _get_all_effects_type()
	for type in effects:
		_shown_lines[type] = {}
	_update_lines()


func emit_smoke_fx() -> void:
	$SmokeParticles2D.emitting = true


func _get_indicator_by_type(type : CellIcons.Type) -> IndicatorCellIcon:
	return _indicators[int(type)]


func _get_effect_by_type(type : CellIcons.Type) -> Sprite2D:
	return _effects[int(type) - FIRST_EFFECT_INDEX] # Be smarter don't do like this 


func _get_all_effects_type() -> Array[CellIcons.Type]:
	return [CellIcons.Type.DIRT]


func _update_lines() -> void:
	for i in _indicators:
		i.visible = false
	var effects := _get_all_effects_type()
	for type in effects:
		var effect := _get_effect_by_type(type)
		effect.visible = is_icon_type(CellIcons.Type.DIRT)
	for type in _shown_lines:
		if not _shown_lines[type].is_empty() and not type in effects:
			var indicator := _get_indicator_by_type(type)
			indicator.set_lines(_shown_lines[type].keys())
			indicator.visible = true

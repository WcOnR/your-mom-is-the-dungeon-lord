class_name SettingHolder extends Node


signal runtime_setting_changed(_name)


var _settings : GameSettings = null
var _runtime_settings : Dictionary = {}


func get_settings() -> GameSettings:
	if _settings == null:
		_settings = load("res://game_objects/game_settings.tres")
	return _settings


func reg_runtime_setting(_name : StringName, val : Variant) -> void:
	_runtime_settings[_name] = val


func set_runtime_setting(_name : StringName, val : Variant) -> void:
	if _name in _runtime_settings:
		var old_val = _runtime_settings[_name]
		_runtime_settings[_name] = val
		if val != old_val:
			runtime_setting_changed.emit(_name)
	else:
		print("SETTING NOT REGESTRED")


func get_runtime_setting(_name : StringName) -> Variant:
	if _name in _runtime_settings:
		return _runtime_settings[_name]
	return null

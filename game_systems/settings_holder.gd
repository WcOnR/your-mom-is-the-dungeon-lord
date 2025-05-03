class_name SettingHolder extends Node

var _settings : GameSettings = null

func get_settings() -> GameSettings:
	if _settings == null:
		_settings = load("res://game_objects/game_settings.tres")
	return _settings

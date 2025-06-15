class_name SettingsBar extends Control


@export var on_icon : Texture = null
@export var off_icon : Texture = null
@export var setting_label : String
@export var setting_name : StringName

@onready var bar : ProgressBar = %Bar

var setting_name_on : StringName
var _hold_bar : bool = false

func _ready() -> void:
	%Label.text = setting_label
	setting_name_on = setting_name + "_on"
	_update_view()
	SettingsManager.runtime_setting_changed.connect(_on_runtime_setting_changed)
	%SwitchButton.pressed.connect(_on_switch)


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("click"):
		var rect := bar.get_rect()
		rect.position = bar.global_position
		if rect.intersects(Rect2(event.position, Vector2.ONE)):
			_hold_bar = true
	if _hold_bar and event.is_action_released("click"):
		_hold_bar = false
	if _hold_bar and event is InputEventMouse:
		var rect := bar.get_rect()
		var val : float = event.position.x - bar.global_position.x
		val = val * 100.0 / rect.size.x
		val = clampf(val, 1.0, 100.0)
		SettingsManager.set_runtime_setting(setting_name, roundf(val))


func _update_view() -> void:
	bar.value = SettingsManager.get_runtime_setting(setting_name)
	if SettingsManager.get_runtime_setting(setting_name_on):
		%SwitchIcon.texture = on_icon
		bar.modulate = Color.WHITE
	else:
		%SwitchIcon.texture = off_icon
		bar.modulate = Color.DIM_GRAY


func _on_runtime_setting_changed(_name : StringName) -> void:
	if _name == setting_name or _name == setting_name_on:
		_update_view()


func _on_switch() -> void:
	var cur = SettingsManager.get_runtime_setting(setting_name_on) as bool
	SettingsManager.set_runtime_setting(setting_name_on, !cur)

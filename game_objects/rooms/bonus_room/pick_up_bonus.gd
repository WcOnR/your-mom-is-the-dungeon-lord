class_name PickUpBonus extends Area2D

@export var game_mode : NodePath
@export var bonus : NodePath

var _game_mode : BonusGameMode = null
var _is_enabled := true


func _ready() -> void:
	_game_mode = get_node(game_mode)
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func _on_click_action(_data : ClickData) -> void:
	if _is_enabled and _is_click_on_me(_data):
		_game_mode.pick_up_done()
		get_node(bonus).visible = false
		_is_enabled = false


func _is_click_on_me(_data : ClickData) -> bool:
	var space = get_world_2d().direct_space_state
	var collider := GameInputManagerSystem.is_click_on_area(space, _data)
	return collider == self

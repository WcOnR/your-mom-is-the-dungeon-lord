class_name PickUpBonus extends Area2D

@export var game_mode : NodePath
@export var bonus : NodePath
@export var pick_up_sounds : Array[AudioData] = []

var _game_mode : BonusGameMode = null
var _is_enabled := true
var _count := 0

const MAX_COUNT := 3


func _ready() -> void:
	_game_mode = get_node(game_mode)
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func _on_click_action(_data : ClickData) -> void:
	if _is_enabled and _is_click_on_me(_data):
		SoundSystem.play_sound(pick_up_sounds[_count])
		_count = _count + 1
		var _bonus := get_node(bonus) as Node2D
		if _count == MAX_COUNT:
			_bonus.visible = false
			_is_enabled = false
			await get_tree().create_timer(0.5).timeout
			_game_mode.pick_up_done()
		else:
			_bonus.rotation = (deg_to_rad(2.5 * (_count * 2.0 - 3.0)))


func _is_click_on_me(_data : ClickData) -> bool:
	var space = get_world_2d().direct_space_state
	var collider := GameInputManagerSystem.is_click_on_area(space, _data)
	return collider == self

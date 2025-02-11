class_name MouseFollower extends Node2D

const pack : PackedScene = preload("res://system/mouse_follower.tscn")

var _data : Variant = null

signal dropped(pos : Vector2, data : Variant)
signal position_updated(pos : Vector2, data : Variant)


static func create(texture : Texture2D, data : Variant, parent : Node) -> MouseFollower:
	var follower := pack.instantiate() as MouseFollower
	follower.set_texture(texture)
	follower.set_data(data)
	parent.add_child(follower)
	return follower


func set_texture(texture : Texture2D) -> void:
	$Sprite2D.texture = texture


func set_data(data : Variant) -> void:
	_data = data


func _process(_delta: float) -> void:
	var old_global_position := global_position
	global_position = get_global_mouse_position()
	if old_global_position != global_position:
		position_updated.emit(global_position, _data)


func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		dropped.emit(global_position, _data)
		get_parent().remove_child(self)
		queue_free()

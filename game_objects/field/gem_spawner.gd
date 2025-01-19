class_name GemSpawner extends RefCounted

const gem_scene : PackedScene = preload("res://game_objects/gems/gem.tscn")

var id : Vector2i = Vector2i.ZERO
var _field : Field = null
var _enabled : bool = false



func initialize(cell_id : Vector2i, field : Field) -> void:
	id = cell_id
	_field = field


func set_enabled(enabled : bool) -> void:
	_enabled = enabled


func try_spawn_gem() -> void:
	if _enabled and _is_spawn_point_free():
		_create_gem()


func _is_spawn_point_free() -> bool:
	return _field.grid.is_cell_free(id)


func _create_gem() -> void:
	var gem := gem_scene.instantiate() as Gem
	_field.add_child(gem)
	gem.initialize(id, _field, _field.gem_set.gem_types.pick_random())

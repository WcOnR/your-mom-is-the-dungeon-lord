class_name Field extends Node2D

@export var gem_set : GemSet
@export var min_gem : int = 2
@export var player : NodePath 
@export var line_holder : NodePath

@onready var tile_map : TileMapLayer = $TileMapLayer
@onready var gem_scene : PackedScene = preload("res://game_objects/gems/gem.tscn")
var size : Vector2i = Vector2i.ZERO
var cell_size : Vector2 = Vector2.ZERO
var grid : Grid = null
var _player : Player = null
var _line_holder : LineHolder = null

const INVALID_ID := Vector2i(-1, -1)


func _ready() -> void:
	_player = get_node(player) as Player
	_line_holder = get_node(line_holder)
	_grab_tile_map_data()
	_check_field()
	_start_update_fall()
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func _check_field() -> void:
	for x in size.x:
		if not _is_it_blocked(Vector2i(x, 0)):
			_create_gem(Vector2i(x, -1))


func _create_gem(cell_id : Vector2i) -> void:
	var gem := gem_scene.instantiate() as Gem
	add_child(gem)
	var offset := cell_size.y * cell_id.x / size.x 
	gem.position = get_cell_position(cell_id) - Vector2(0, offset)
	gem.initialize(cell_id, self, gem_set.gem_types.pick_random())
	gem.try_to_fall()


func _delete_gem(gem : Gem) -> void:
	remove_child(gem)
	block_cell(gem.get_static_cell_id(), null)
	gem.queue_free()


func get_next_cell(cell_id : Vector2i) -> Vector2i:
	var next_id := cell_id
	next_id.y += 1
	if next_id.y >= size.y or _is_it_blocked(next_id):
		return INVALID_ID
	return next_id


func _is_it_blocked(cell_id : Vector2i) -> bool:
	if cell_id.x < 0 or cell_id.y < 0:
		return false
	return grid.get_gem(cell_id) != null


func block_cell(cell_id : Vector2i, block : Gem) -> void:
	if cell_id.x >= 0 and cell_id.y >= 0:
		grid.set_gem(block, cell_id)
		if block == null:
			_check_field()


func _on_click_action(data : ClickData) -> void:
	var old_cell_id := _get_cell_id(data.start_position)
	var cell_id := _get_cell_id(data.end_position)
	if cell_id != old_cell_id or not _is_valid_cell_id(cell_id):
		return
	var to_remove : Array[Gem] = _get_all_near_gems(grid.get_gem(cell_id))
	if to_remove.size() >= min_gem:
		var gem_type := to_remove[0]._gem_type
		for gem in to_remove:
			_delete_gem(gem)
		if gem_type.actions:
			gem_type.actions.run_event(ActionList.ON_ACTION, [to_remove.size(), _player, _line_holder])


func _get_all_near_gems(gem : Gem) -> Array[Gem]:
	if gem == null:
		return []
	var result : Array[Gem] = [gem]
	var i : int = 0
	while i < result.size():
		var index : Vector2i = result[i].get_static_cell_id()
		var n : = _get_cell_neighbors(index)
		for _c in n:
			if not (_c in result) and _c.get_gem_type() == result[0].get_gem_type():
				result.append(_c)
		i += 1
	return result


func _start_update_fall() -> void:
	var timer := Timer.new()
	timer.timeout.connect(_update_fall)
	timer.wait_time = 0.1
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)


func _update_fall() -> void:
	for x in size.x:
		var is_fall := false
		for y in size.y:
			var gem := grid.get_gem(Vector2i(x, size.y-1-y))
			if gem == null:
				is_fall = true
			elif is_fall:
				gem.try_to_fall()


func _grab_tile_map_data() -> void:
	while tile_map.get_cell_source_id(Vector2i(size.x, 0)) != -1:
		size.x += 1
	while tile_map.get_cell_source_id(Vector2i(0, size.y)) != -1:
		size.y += 1
	cell_size = Vector2(tile_map.tile_set.tile_size)
	grid = Grid.new()
	grid.initialize(size)


func _get_cell_id(pos : Vector2) -> Vector2i:
	pos = pos - global_position
	var real_size := cell_size * Vector2(size)
	if pos.x < 0.0 or pos.y < 0.0 or pos.x > real_size.x or pos.y > real_size.y:
		return INVALID_ID
	return Vector2i(int(pos.x / cell_size.x), int(pos.y / cell_size.y))


func get_cell_position(cell_id : Vector2i) -> Vector2:
	return Vector2(cell_id) * cell_size


func _is_valid_cell_id(cell_id : Vector2i) -> bool:
	return cell_id.x >= 0 and cell_id.x < size.x and cell_id.y >=0 and cell_id.y < size.y


func _get_cell_neighbors(id : Vector2i) -> Array[Gem]:
	var result :Array[Gem] = []
	var map : Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]
	for m in map:
		var tmp := id + m
		if _is_valid_cell_id(tmp):
			var gem := grid.get_gem(tmp)
			if gem != null:
				result.append(gem)
	return result

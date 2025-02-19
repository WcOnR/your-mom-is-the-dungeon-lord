class_name Grid extends RefCounted

signal grid_idle
signal grid_stopped

var gems : Array[Gem] = []
var _size : Vector2i = Vector2i.ZERO
var _cell_size : Vector2 = Vector2.ZERO
var _is_spawn_allowed : bool = true

const INVALID_ID := Vector2i(-1, -1)


func initialize(size : Vector2i, cell_size : Vector2) -> void:
	_size = size
	_cell_size = cell_size


func is_idle() -> bool:
	return not gems.is_empty() and _is_all_gem_in_state(Gem.State.IDLE)


func is_spawn_allowed() -> bool:
	return _is_spawn_allowed


func add_gem(gem : Gem) -> void:
	_append_unique_gem(gem)


func remove_gem(gem : Gem) -> void:
	gem.state_changed.disconnect(_on_state_changed)
	gems.erase(gem)


func get_cell_position(id : Vector2i) -> Vector2:
	return _cell_size * Vector2(id)


func get_cell_id(pos : Vector2) -> Vector2i:
	return Vector2i(int(pos.x / _cell_size.x), int(pos.y / _cell_size.y))


func get_size() -> Vector2i:
	return _size


func get_cell_size() -> Vector2:
	return _cell_size


func is_valid_cell_id(id : Vector2i) -> bool:
	return id.x >= 0 and id.x < _size.x and id.y >=0 and id.y < _size.y


func reshuffle() -> void:
	_is_spawn_allowed = false
	if not is_idle():
		await grid_idle
	var map := {}
	for g in gems:
		map[g] = get_cell_id(g.position)
	for i in gems.size():
		var ran : int = randi_range(0, gems.size() - 1)
		if i == ran:
			continue
		var gem_from := map.keys()[i] as Gem
		var gem_to := map.keys()[ran] as Gem
		var tmp := map[gem_from] as Vector2i
		map[gem_from] = map[gem_to] as Vector2i
		map[gem_to] = tmp
	for g in map.keys():
		g.move_to_cell_id(map[g])
	await grid_stopped
	_is_spawn_allowed = true
	for g in gems:
		g.ready_to_idle()


func get_map() -> Dictionary:
	var map := {}
	for g in gems:
		if g.is_state(Gem.State.IDLE):
			map[get_cell_id(g.position)] = g
	return map


func get_intersects(offset : Vector2) -> Array[Gem]:
	var result : Array[Gem] = []
	var cell_rect := Rect2(offset, _cell_size)
	for g in gems:
		if Rect2(g.position, _cell_size).intersects(cell_rect):
			result.append(g)
	return result


func get_gems_in_cell(id : Vector2i) -> Array[Gem]:
	return get_intersects(get_cell_position(id))


func is_cell_free(id : Vector2i) -> bool:
	return get_gems_in_cell(id).is_empty()


func _is_all_gem_in_state(state : Gem.State) -> bool:
	for g in gems:
		if not g.is_state(state):
			return false
	return true


func _append_unique_gem(gem : Gem) -> void:
	if gem in gems:
		return
	gems.append(gem)
	gem.state_changed.connect(_on_state_changed.bind(gem))


func _on_state_changed(_gem : Gem) -> void:
	if is_idle():
		grid_idle.emit()
	elif _is_all_gem_in_state(Gem.State.STOPPED):
		grid_stopped.emit()

class_name Grid extends RefCounted

signal grid_idle

var grid : Array[Gem] = []
var _size : Vector2i = Vector2i.ZERO


func initialize(size : Vector2i) -> void:
	_size = size
	for x in size.x :
		for y in size.y :
			grid.append(null)


func is_idle() -> bool:
	for g in grid:
		if not g or not g.is_state(Gem.State.IDLE):
			return false
	return true


func reshuffle() -> void:
	for x in _size.x :
		for y in _size.y :
			var cell_id : int = _size.y * x + y
			var ran : int = randi_range(0, _size.y * _size.x - 1)
			_swap_gem(cell_id, ran)


func _swap_gem(from : int, to : int) -> void:
	if from == to:
		return
	var tmp := grid[from]
	var tmp_0 := grid[from]._cell_id
	var tmp_1 := grid[to]._cell_id
	grid[from] = grid[to]
	grid[from].move_to_cell_id(tmp_0)
	grid[to] = tmp
	grid[to].move_to_cell_id(tmp_1)

func _on_state_changed() -> void:
	if is_idle():
		grid_idle.emit()
	#print("grid is idle! ")

func set_gem(gem : Gem, id : Vector2i) -> void:
	var index : int = _size.y * id.x + id.y
	if grid[index] :
		grid[index].state_changed.disconnect(_on_state_changed)
	if gem:
		gem.state_changed.connect(_on_state_changed)
	grid[index] = gem


func get_gem(id : Vector2i) -> Gem:
	return grid[_size.y * id.x + id.y]

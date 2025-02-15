class_name Field extends Node2D

@export var gem_set : GemSet
@export var min_gem : int = 2
@export var line_holder : NodePath

@onready var tile_map : TileMapLayer = $TileMapLayer
@onready var tile_map_h : TileMapLayer = $TileMapLayer_h

var grid : Grid = null
var _player : Player = null
var _line_holder : LineHolder = null
var _enabled : bool = false
var _spawners : Array[GemSpawner] = []
var _game_mode : BattleGameMode = null

const DAMAGE_MULTIPLIER := 10
const ON_DROP : StringName = "on_drop"
const ON_MOVE : StringName = "on_move"

signal gem_collapsed
signal action_clicked


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("Player") as Player
	_game_mode = get_tree().get_first_node_in_group("GameMode") as BattleGameMode
	_line_holder = get_node(line_holder)
	_init_grid_with_tile_map()
	_start_spawners()
	GameInputManagerSystem.on_click_end.connect(_on_click_action)


func get_next_cell(cell_id : Vector2i) -> Vector2i:
	var next_id := cell_id
	next_id.y += 1
	if next_id.y >= grid.get_size().y:
		return Grid.INVALID_ID
	return next_id


func enable_input(_enable_input : bool) -> void:
	_enabled = _enable_input


func is_valid_cell_id(cell_id : Vector2i) -> bool:
	return grid.is_valid_cell_id(cell_id)


func start_drag(follower : MouseFollower) -> void:
	follower.dropped.connect(_on_consumable_drop)
	follower.position_updated.connect(_on_consumable_pos_updated)


func highlight_cells(cells : Array[Vector2i]) -> void:
	tile_map_h.clear()
	for cell_id in cells:
		tile_map_h.set_cell(cell_id, 0, Vector2i.ZERO)


func collapse_ids(to_remove : Array[Vector2i]) -> void:
	var gems : Array[Gem] = []
	var map := grid.get_map()
	for cell_id in to_remove:
		gems.append(map.get(cell_id) as Gem)
	_collapse_gems(gems)


func _process(_delta: float) -> void:
	if grid.is_spawn_allowed():
		_spawn_gems()


func _start_spawners() -> void:
	for spawner in _spawners:
		await get_tree().create_timer(0.05).timeout
		spawner.set_enabled(true)


func _spawn_gems() -> void:
	for spawner in _spawners:
		spawner.try_spawn_gem()


func _delete_gem(gem : Gem) -> void:
	gem.destroy()


func _init_grid_with_tile_map() -> void:
	var size : Vector2i = Vector2i.ZERO
	while tile_map.get_cell_source_id(Vector2i(size.x, 0)) != -1:
		var spawner := GemSpawner.new()
		spawner.initialize(Vector2i(size.x, 0), self)
		_spawners.append(spawner)						# TODO mark real spawn points
		size.x += 1
	while tile_map.get_cell_source_id(Vector2i(0, size.y)) != -1:
		size.y += 1
	grid = Grid.new()
	grid.initialize(size, Vector2(tile_map.tile_set.tile_size))


func _on_click_action(data : ClickData) -> void:
	if not _game_mode.is_state(BattleGameMode.State.PLAYER_MOVE):
		return
	var old_cell_id := grid.get_cell_id(data.start_position - global_position)
	var cell_id := grid.get_cell_id(data.end_position - global_position)
	if not _enabled or cell_id != old_cell_id or not is_valid_cell_id(cell_id):
		return
	var to_remove : Array[Gem] = _get_all_near_gems(cell_id)
	if to_remove.size() >= min_gem:
		_collapse_gems(to_remove)
		action_clicked.emit()


func _collapse_gems(to_remove : Array[Gem]) -> void:
	var types = {}
	for gem in to_remove:
		var gem_type := gem.get_gem_type()
		if gem_type in types:
			types[gem_type] += 1
		else:
			types[gem_type] = 1
		_delete_gem(gem)
	for gem_type in types.keys():
		if gem_type.actions:
			var val := _mult_func(types[gem_type])
			gem_type.actions.run_event(ActionList.ON_ACTION, [val, _player, _line_holder])
	gem_collapsed.emit()


func _mult_func(count : int) -> int:
	if count >= 10:
		return 999
	return (count + _fib(count - min_gem)) * DAMAGE_MULTIPLIER


func _fib(f : int) -> int:
	if f <= 1:
		return 0
	if f == 2:
		return 1
	var val_1 := 1
	var val_2 := 0
	var res := val_1 + val_2
	f -= 3
	while f > 0:
		f -= 1
		val_2 = val_1
		val_1 = res
		res = val_1 + val_2
	return res
	


func _get_all_near_gems(cell_id : Vector2i) -> Array[Gem]:
	var map := grid.get_map()
	var gem := map.get(cell_id) as Gem
	if gem == null:
		return []
	var gem_type := gem.get_gem_type()
	var result : Array[Gem] = [gem]
	var i : int = 0
	while i < result.size():
		var n : = _get_cell_neighbors(map, grid.get_cell_id(result[i].position))
		for _c in n:
			if not (_c in result) and _c.get_gem_type() == gem_type:
				result.append(_c)
		i += 1
	return result


func _get_cell_neighbors(map : Dictionary, id : Vector2i) -> Array[Gem]:
	var result :Array[Gem] = []
	var nswe : Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]
	for dir in nswe:
		var tmp := id + dir
		if is_valid_cell_id(tmp):
			var gem := map.get(tmp) as Gem #grid.get_occupied_gem(tmp)
			if gem != null:
				result.append(gem)
	return result


func _on_consumable_pos_updated(_position: Vector2, _data : Variant) -> void:
	var cell_id := grid.get_cell_id(_position - global_position)
	if is_valid_cell_id(cell_id):
		var item_preset := _data as ItemPreset
		item_preset.action.run(ON_MOVE, [self, cell_id])
	else:
		tile_map_h.clear()


func _on_consumable_drop(_position: Vector2, _data : Variant) -> void:
	var cell_id := grid.get_cell_id(_position - global_position)
	tile_map_h.clear()
	var item_preset := _data as ItemPreset
	if is_valid_cell_id(cell_id):
		item_preset.action.run(ON_DROP, [self, cell_id])
		_player.inventory_comp.consume_item(item_preset)

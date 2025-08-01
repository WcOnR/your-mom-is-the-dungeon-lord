class_name Field extends Node2D

@export var gem_set : GemSet
@export var min_gem : int = 2
@export var cell_icons : PackedScene
@export var collapse_sound : AudioData = null
@export var shuffle_sound : AudioData = null
@export var ball_drop_sound : AudioData = null

@onready var tile_map : TileMapLayer = $TileMapLayer
@onready var tile_map_h : TileMapLayer = $TileMapLayer_h

var grid : Grid = null
var _player : Player = null
var _line_holder : LineHolder = null
var _enabled : bool = false
var _spawners : Array[GemSpawner] = []
var _game_mode : BattleGameMode = null
var _cell_icons : Array[CellIcons] = []

signal gem_collapsed
signal action_clicked


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("Player") as Player
	_line_holder = get_tree().get_first_node_in_group("LineHolder")
	_init_grid_with_tile_map()
	var game_mode : Node = get_tree().get_first_node_in_group("GameMode")
	if game_mode != null and game_mode is BattleGameMode:
		_game_mode = game_mode as BattleGameMode
		_game_mode.battle_started.connect(_start_spawners)
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


func highlight_cells(cells : Array[Vector2i], index : int = 0) -> void:
	tile_map_h.clear()
	for cell_id in cells:
		tile_map_h.set_cell(cell_id, 0, Vector2i(index, 0))


func collapse_ids(to_remove : Array[Vector2i], initiator : Node) -> void:
	var gems : Array[Gem] = []
	var map := grid.get_map()
	for cell_id in to_remove:
		gems.append(map.get(cell_id) as Gem)
	_collapse_gems(gems, initiator)


func clean_field() -> void:
	while not grid.gems.is_empty():
		_delete_gem(grid.gems[0])


func hit_target(target : Vector2i, initiator : Node) -> void:
	_collapse_by_id(target, initiator)


func show_icon(cell_id : Vector2i, type : CellIcons.Type, _show : bool, line : int) -> void:
	_get_cell_icons(cell_id).set_icon_visibility(type, _show, line)


func clean_icons() -> void:
	for icons in _cell_icons:
		icons.clean_icons()


func clean_effects() -> void:
	for icons in _cell_icons:
		icons.clean_effects()


func get_max_gem_cluster_by_type(gem_type : GemType) -> Array[Vector2i]:
	var pool : Array[Vector2i] = []
	for gem in grid.gems:
		if gem.get_gem_type() == gem_type:
			pool.append(grid.get_cell_id(gem.position))
	var clusters : Array = []
	var map := grid.get_map()
	while not pool.is_empty():
		var cluster := _get_all_near_gems(pool[0], map)
		for gem in cluster:
			pool.erase(grid.get_cell_id(gem.position))
		clusters.append(cluster)
	var max_cluster : Array[Gem] = []
	for cluster in clusters:
		if cluster.size() > max_cluster.size():
			max_cluster = cluster
	var result : Array[Vector2i] = []
	for gem in max_cluster:
		result.append(grid.get_cell_id(gem.position))
	return result


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
	_get_cell_icons(grid.get_cell_id(gem.position)).emit_smoke_fx()
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
	var tile_size := Vector2(tile_map.tile_set.tile_size)
	grid = Grid.new()
	grid.initialize(size, tile_size)
	grid.shuffle_sound = shuffle_sound
	var half_size := tile_size / 2.0
	for x in size.x:
		for y in size.y:
			var icons := cell_icons.instantiate() as CellIcons
			add_child(icons)
			icons.position = grid.get_cell_position(Vector2i(x, y)) + half_size
			_cell_icons.append(icons)


func _collapse_by_id(cell_id : Vector2i, initiator : Node) -> bool:
	if not is_valid_cell_id(cell_id):
		return false
	var icons := _get_cell_icons(cell_id)
	if icons.is_icon_type(CellIcons.Type.DIRT):
		return false
	var map := grid.get_map()
	var to_remove : Array[Gem] = _get_all_near_gems(cell_id, map)
	if to_remove.size() >= min_gem:
		_collapse_gems(to_remove, initiator)
		return true
	return false


func _get_cell_icons(cell_id : Vector2i) -> CellIcons:
	var id := cell_id.x * grid.get_size().y + cell_id.y
	return _cell_icons[id]


func _on_click_action(data : ClickData) -> void:
	if _game_mode == null or not _game_mode.is_state(BattleGameMode.State.PLAYER_MOVE):
		return
	var old_cell_id := grid.get_cell_id(data.start_position - global_position)
	var cell_id := grid.get_cell_id(data.end_position - global_position)
	if not _enabled or cell_id != old_cell_id:
		return
	if _collapse_by_id(cell_id, _player):
		action_clicked.emit()


func _collapse_gems(to_remove : Array[Gem], initiator : Node) -> void:
	var types = {}
	for gem in to_remove:
		var gem_type := gem.get_gem_type()
		if gem_type in types:
			types[gem_type] += 1
		else:
			types[gem_type] = 1
		_delete_gem(gem)
	for gem_type in types.keys():
		if gem_type.action:
			var val := _mult_func(types[gem_type])
			gem_type.action.on_action(val, initiator)
	gem_collapsed.emit()
	SoundSystem.play_sound(collapse_sound)


func _mult_func(count : int) -> int:
	if count >= 10:
		return 999
	return count + _fib(count - min_gem)


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


func _get_all_near_gems(cell_id : Vector2i, map : Dictionary) -> Array[Gem]:
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
	var diff := _position - global_position
	var cell_id := grid.get_cell_id(diff)
	if is_valid_cell_id(cell_id) and grid.is_idle():
		var item_preset := _data as ItemPreset
		var offset := (diff - grid.get_cell_position(cell_id)) / grid.get_cell_size()
		item_preset.action.on_move(self, cell_id, offset)
	else:
		tile_map_h.clear()


func _on_consumable_drop(_position: Vector2, _data : Variant) -> void:
	var diff := _position - global_position
	var cell_id := grid.get_cell_id(diff)
	tile_map_h.clear()
	var item_preset := _data as ItemPreset
	if is_valid_cell_id(cell_id):
		var offset := (diff - grid.get_cell_position(cell_id)) / grid.get_cell_size()
		SoundSystem.play_sound(ball_drop_sound)
		item_preset.action.on_drop(self, cell_id, offset)
		_player.inventory_comp.consume_item(item_preset)

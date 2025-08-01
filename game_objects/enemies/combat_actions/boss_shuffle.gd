class_name BossShuffle extends RefCounted


func get_move_ids(field : Field) -> Dictionary:
	var map := {}
	var size := field.grid.get_size()
	for g in field.grid.gems:
		map[g] = field.grid.get_cell_id(g.position)
	for gem in field.grid.gems:
		var pos := map[gem] as Vector2i
		pos.x = wrapi(pos.x + pos.y + 1, 0, size.x)
		pos.y = wrapi(pos.x + pos.y + 1, 0, size.y)
		map[gem] = pos
	return map

class_name UpDownShuffle extends Shuffle


func get_move_ids(field : Field) -> Dictionary:
	var map := {}
	var size := field.grid.get_size()
	for g in field.grid.gems:
		map[g] = field.grid.get_cell_id(g.position)
	for gem in field.grid.gems:
		var pos := map[gem] as Vector2i
		pos.y = size.y - pos.y - 1
		map[gem] = pos
	return map

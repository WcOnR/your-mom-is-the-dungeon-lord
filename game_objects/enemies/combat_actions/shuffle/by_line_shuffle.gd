class_name ByLineShuffle extends Shuffle


func get_move_ids(field : Field) -> Dictionary:
	var map := {}
	var size := field.grid.get_size()
	for g in field.grid.gems:
		map[g] = field.grid.get_cell_id(g.position)
	for gem in field.grid.gems:
		var pos := map[gem] as Vector2i
		if pos.y % 2 == 0:
			pos.x = (pos.x + 1) % size.x
		else:
			pos.x = pos.x - 1
			if pos.x < 0:
				pos.x = size.x + pos.x
		map[gem] = pos
	return map

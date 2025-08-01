class_name TwoCornerAttack extends FieldSelector

func get_target_ids(field : Field) -> Array[Vector2i]:
	var cell_ids : Array[Vector2i] = []
	var size := field.grid.get_size()
	if randi() % 2 == 0:
		for y in 3:
			for x in (3 - y):
				cell_ids.append(Vector2i(x, y))
		for y in 3:
			for x in (y + 1):
				cell_ids.append(Vector2i(size.x - x - 1, size.y - 3 + y))
	else:
		for y in 3:
			for x in (3 - y):
				cell_ids.append(Vector2i(size.x - x - 1, y))
		for y in 3:
			for x in (y + 1):
				cell_ids.append(Vector2i(x, size.y - 3 + y))
	return cell_ids

class_name MultVerticalSlash extends FieldSelector

func get_target_ids(field : Field) -> Array[Vector2i]:
	var cell_ids : Array[Vector2i] = []
	var size := field.grid.get_size()
	var ptr := randi_range(0, 2)
	var lines : Array[int] = []
	while ptr < size.x:
		lines.append(ptr)
		ptr += randi_range(1, 3)
	lines.shuffle()
	while lines.size() > 3:
		lines.pop_back()
	for x in lines:
		for y in size.y:
			cell_ids.append(Vector2i(x, y))
	return cell_ids

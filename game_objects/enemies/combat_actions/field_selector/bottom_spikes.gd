class_name BottomSpikes extends FieldSelector


func get_target_ids(field : Field) -> Array[Vector2i]:
	var cell_ids : Array[Vector2i] = []
	var size := field.grid.get_size()
	var x := randi_range(0, 1)
	while x < size.x:
		for y in 2:
			cell_ids.append(Vector2i(x, size.y - y - 1))
		x += 2
	return cell_ids

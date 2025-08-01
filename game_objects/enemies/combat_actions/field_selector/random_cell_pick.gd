class_name RandomCellPick extends FieldSelector


func get_target_ids(field : Field) -> Array[Vector2i]:
	var size := field.grid.get_size()
	return [Vector2i(randi_range(0, size.x - 1), randi_range(0, size.y - 1))]

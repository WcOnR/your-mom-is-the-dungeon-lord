class_name HorizontalSlash extends RefCounted


func get_target_ids(field : Field) -> Array[Vector2i]:
	var cell_ids : Array[Vector2i] = []
	var size := field.grid.get_size()
	var y := randi_range(0, size.y - 1)
	for x in size.x:
		cell_ids.append(Vector2i(x, y))
	return cell_ids

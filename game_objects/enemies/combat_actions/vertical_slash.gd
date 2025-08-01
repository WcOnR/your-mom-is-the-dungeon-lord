class_name VerticalSlash extends RefCounted


func get_target_ids(field : Field) -> Array[Vector2i]:
	var cell_ids : Array[Vector2i] = []
	var size := field.grid.get_size()
	var x := randi_range(0, size.x - 1)
	for y in size.y:
		cell_ids.append(Vector2i(x, y))
	return cell_ids

class_name FieldCleanCons extends ItemAction

const CLEAR_INDEX : int = 1


func on_move(field : Field, _id : Vector2i, _offset : Vector2) -> void:
	field.highlight_cells(_get_all_cells(field), CLEAR_INDEX)


func on_drop(field : Field, _id : Vector2i, _offset : Vector2) -> void:
	field.clean_field()


func _get_all_cells(field : Field) -> Array[Vector2i]:
	var size := field.grid.get_size()
	var highlight : Array[Vector2i] = []
	for x in size.x:
		for y in size.y:
			highlight.append(Vector2i(x, y))
	return highlight

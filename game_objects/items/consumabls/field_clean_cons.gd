class_name FieldCleanCons extends RefCounted

const CLEAR_INDEX : int = 1


func on_move(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	field.highlight_cells(_get_all_cells(field), CLEAR_INDEX)
	return false


func on_drop(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	field.clean_field()
	return false


func _get_all_cells(field : Field) -> Array[Vector2i]:
	var size := field.grid.get_size()
	var highlight : Array[Vector2i] = []
	for x in size.x:
		for y in size.y:
			highlight.append(Vector2i(x, y))
	return highlight

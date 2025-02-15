class_name VLineCons extends Node


func on_move(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	field.highlight_cells(_get_v_line(field, id))
	return false


func on_drop(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	field.collapse_ids(_get_v_line(field, id))
	return false


func _get_v_line(field : Field, id : Vector2i) -> Array[Vector2i]:
	var size_y := field.grid.get_size().y
	var highlight : Array[Vector2i] = []
	for i in size_y:
		highlight.append(Vector2i(id.x, i))
	return highlight

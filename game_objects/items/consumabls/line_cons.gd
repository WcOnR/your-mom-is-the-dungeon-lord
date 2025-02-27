class_name LineCons extends RefCounted


func on_move(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	var offset := args[2] as Vector2
	field.highlight_cells(_get_target_line(offset, field, id))
	return false


func on_drop(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	var player = field.get_tree().get_first_node_in_group("Player") as Player
	var offset := args[2] as Vector2
	field.collapse_ids(_get_target_line(offset, field, id), player)
	return false


func _get_target_line(offset : Vector2, field : Field, id : Vector2i) -> Array[Vector2i]:
	if _is_h_line(offset):
		return _get_h_line(field, id)
	return _get_v_line(field, id)


func _is_h_line(offset : Vector2) -> bool:
	var d := offset.x < offset.y
	var rd := offset.x < (1.0 - offset.y)
	return d and rd or (not d and not rd)


func _get_h_line(field : Field, id : Vector2i) -> Array[Vector2i]:
	var size_x := field.grid.get_size().x
	var highlight : Array[Vector2i] = []
	for i in size_x:
		highlight.append(Vector2i(i, id.y))
	return highlight


func _get_v_line(field : Field, id : Vector2i) -> Array[Vector2i]:
	var size_y := field.grid.get_size().y
	var highlight : Array[Vector2i] = []
	for i in size_y:
		highlight.append(Vector2i(id.x, i))
	return highlight

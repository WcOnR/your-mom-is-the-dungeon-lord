class_name HLineCons extends RefCounted


func on_move(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	field.highlight_cells(_get_h_line(field, id))
	return false


func on_drop(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	var player = field.get_tree().get_first_node_in_group("Player") as Player
	field.collapse_ids(_get_h_line(field, id), player)
	return false


func _get_h_line(field : Field, id : Vector2i) -> Array[Vector2i]:
	var size_x := field.grid.get_size().x
	var highlight : Array[Vector2i] = []
	for i in size_x:
		highlight.append(Vector2i(i, id.y))
	return highlight

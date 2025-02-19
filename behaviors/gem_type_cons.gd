class_name GemTypeCons extends RefCounted


func on_move(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	field.highlight_cells(_get_gem_by_type(field, id))
	return false


func on_drop(args : Array[Variant]) -> bool:
	var field := args[0] as Field
	var id := args[1] as Vector2i
	var player = field.get_tree().get_first_node_in_group("Player") as Player
	field.collapse_ids(_get_gem_by_type(field, id), player)
	return false


func _get_gem_by_type(field : Field, id : Vector2i) -> Array[Vector2i]:
	var map := field.grid.get_map()
	var gem_type := map.get(id).get_gem_type() as GemType
	var highlight : Array[Vector2i] = []
	for key in map.keys():
		if map[key].get_gem_type() == gem_type:
			highlight.append(key as Vector2i)
	return highlight

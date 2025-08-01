class_name RandomDirt extends FieldSelector

const COUNT := 2

func get_target_ids(field : Field) -> Array[Vector2i]:
	var size := field.grid.get_size()
	var source := Vector2i(randi_range(0, size.x - 1), randi_range(0, size.y - 1))
	var cell_ids : Array[Vector2i] = [source]
	var lc := source - Vector2i(Vector2.ONE * COUNT)
	var max_l := 2 * COUNT * COUNT
	var double_count := COUNT * 2
	for x in double_count:
		for y in double_count:
			var tmp := lc + Vector2i(x, y)
			if field.grid.is_valid_cell_id(tmp):
				var dif := Vector2(source - tmp)
				var l := dif.length_squared() / max_l
				if randf() > l:
					cell_ids.append(tmp)
	return cell_ids

class_name RandomCellsPick3 extends FieldSelector

const COUNT := 3

func get_target_ids(field : Field) -> Array[Vector2i]:
	var size := field.grid.get_size()
	var half_size := size / 2
	var dirs : Array[Vector2i] = [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
	var cell_ids : Array[Vector2i] = []
	var is_second := randf() > 0.5
	for i in COUNT:
		var tmp := Vector2i(randi_range(0, half_size.x - 1), randi_range(0, half_size.y - 1))
		dirs.shuffle()
		tmp = tmp + half_size * dirs[0]
		if is_second:
			tmp.y += 1
		dirs.remove_at(0)
		cell_ids.append(tmp)
	return cell_ids

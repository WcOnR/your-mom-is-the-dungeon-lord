class_name RandomCrosstPick extends RefCounted


func get_target_ids(field : Field) -> Array[Vector2i]:
	var size := field.grid.get_size()
	var cell_id := Vector2i(randi_range(1, size.x - 2), randi_range(1, size.y - 2))
	var targets : Array[Vector2i] = [cell_id]
	targets.append(cell_id + Vector2i.LEFT)
	targets.append(cell_id + Vector2i.RIGHT)
	targets.append(cell_id + Vector2i.UP)
	targets.append(cell_id + Vector2i.DOWN)
	return targets

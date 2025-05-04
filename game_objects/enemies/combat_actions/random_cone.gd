class_name RandomCone extends RefCounted


func get_target_ids(field : Field) -> Array[Vector2i]:
	var size := field.grid.get_size()
	var source := Vector2i.ZERO
	var is_horizontal := randf() > 0.5
	var from_zero := randf() > 0.5
	if is_horizontal:
		source.x = randi_range(1, size.x - 2)
		source.y = 0 if from_zero else (size.y - 1)
	else:
		source.y = randi_range(1, size.y - 2)
		source.x = 0 if from_zero else (size.x - 1)
	var targets : Array[Vector2i] = [source]
	var dir := Vector2i.DOWN if is_horizontal else Vector2i.RIGHT
	if not from_zero:
		dir = -dir
	var normal := Vector2i(dir.y, -dir.x)
	for i in 3:
		var tmp := source + dir + normal * (i-1)
		if field.grid.is_valid_cell_id(tmp):
			targets.append(tmp)
	for i in 5:
		var tmp := source + 2 * dir + normal * (i-2)
		if field.grid.is_valid_cell_id(tmp):
			targets.append(tmp)
	return targets

class_name SnakeBite extends RefCounted


func get_target_ids(field : Field) -> Array[Vector2i]:
	var cell_ids : Array[Vector2i] = []
	var size := field.grid.get_size()
	var origin := Vector2i.ZERO
	origin.y = randi_range(1, size.y - 4)
	if randi() % 2 == 0: # is right side
		origin.x = size.x - 2
	var offsets : Array[Vector2i] = [
		Vector2i(0, 0), 
		Vector2i(1, 0), 
		Vector2i(0, 2), 
		Vector2i(1, 2)
	]
	for offset in offsets:
		cell_ids.append(origin + offset)
	return cell_ids

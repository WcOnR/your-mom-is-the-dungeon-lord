class_name FullShuffle extends RefCounted


func get_move_ids(field : Field) -> Dictionary:
	var map := {}
	for g in field.grid.gems:
		map[g] = field.grid.get_cell_id(g.position)
	for i in field.grid.gems.size():
		var ran : int = randi_range(0, field.grid.gems.size() - 1)
		if i == ran:
			continue
		var gem_from := map.keys()[i] as Gem
		var gem_to := map.keys()[ran] as Gem
		var tmp := map[gem_from] as Vector2i
		map[gem_from] = map[gem_to] as Vector2i
		map[gem_to] = tmp
	return map

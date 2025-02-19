class_name IconTileMapLayer extends TileMapLayer

enum Type {CROSS, NONE}


func set_cell_by_type(cell_id : Vector2i, type : Type) -> void:
	var id := Vector2i(-1, -1)
	if type != Type.NONE:
		id = Vector2i(0, int(type))
	set_cell(cell_id, 0, id)

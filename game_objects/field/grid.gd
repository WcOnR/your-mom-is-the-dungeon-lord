class_name Grid extends RefCounted

var grid : Array[Gem] = []
var _size : Vector2i = Vector2i.ZERO


func initialize(size : Vector2i) -> void:
	_size = size
	for x in size.x :
		for y in size.y :
			grid.append(null)


func set_gem(gem : Gem, id : Vector2i) -> void:
	grid[_size.y * id.x + id.y] = gem


func get_gem(id : Vector2i) -> Gem:
	return grid[_size.y * id.x + id.y]

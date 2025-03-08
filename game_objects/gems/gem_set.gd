class_name GemSet extends Resource

@export var gem_types : Array[GemType]


func replace_gem(from_type : GemType, to_type : GemType) -> Array[GemType]:
	var _gem_types := gem_types.duplicate() as Array[GemType]
	_gem_types.erase(from_type)
	_gem_types.append(to_type)
	return _gem_types

class_name Hint extends RefCounted

var title : String = ""
var description : String = ""
var holder : Node


func _init(_title : String, _description : String, _holder : Node) -> void:
	title = _title
	description = _description
	holder = _holder

class_name AnimObjectManager extends Node

var lib : MasterDictionary = preload("res://system/anim_object/curve_lib.tres")
var anims : Array = []


func get_curve(curve : StringName) -> Curve:
	return lib.data.get(curve) as Curve


func start_anim(anim : AnimObject) -> void:
	anims.append([anim])


func start_anim_queue(queue : Array[AnimObject]) -> void:
	if queue.is_empty():
		return
	anims.append(queue.duplicate())


func drop_anim(anim : AnimObject) -> void:
	for i in anims.size():
		var r : int = anims[i].find(anim)
		if r >= 0:
			_remove_anim(i, r)
			return


func _remove_anim(i : int, j : int = 0) -> bool:
	anims[i].remove_at(j)
	if anims[i].is_empty():
		anims.remove_at(i)
		return false
	return true


func _process(delta: float) -> void:
	var i := 0
	while i < anims.size():
		var need_to_step := true
		var anim := anims[i][0] as AnimObject
		if anim.is_invalid() or anim.update(delta):
			need_to_step = _remove_anim(i)
		if need_to_step:
			i += 1

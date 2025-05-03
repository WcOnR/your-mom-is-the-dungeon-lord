class_name AIBehavior extends Resource

@export var behavior : GDScript = null
@export var args : Array[Variant] = []

const GET_ACTION : StringName = "get_next_action"

var script_object = null

func get_next_action(enemy : Enemy) -> Action:
	if not script_object:
		script_object = behavior.new()
	var callable = Callable(script_object, GET_ACTION)
	return callable.call(enemy, args)

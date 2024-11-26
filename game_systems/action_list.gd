class_name ActionList extends Resource

@export var actions : Array[Action]

const ON_ACTION : StringName = "on_action"

func run_event(event : StringName, extra_args : Array[Variant] = []) -> void:
	var to_remove : Array[Action] = []
	for action in actions:
		if action.run(event, extra_args):
			to_remove.append(action)
	for action in to_remove:
		actions.erase(action)

class_name ActionList extends Resource

@export var actions : Array[Action]

const ON_ACTION : StringName = "on_action"

func run_event(event : StringName, extra_args : Array[Variant] = []) -> void:
	for action in actions:
		action.run(event, extra_args)

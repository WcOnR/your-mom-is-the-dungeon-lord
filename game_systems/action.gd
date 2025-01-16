class_name Action extends Resource

@export var behavior : GDScript = null
@export var args : Array[Variant] = []

var script_object = null

func run(event_name : StringName, extra_args : Array[Variant] = []) -> void:
	if not script_object:
		script_object = behavior.new()
	if event_name in script_object:
		var callable = Callable(script_object, event_name)
		var full_args : Array[Variant] = args
		if not extra_args.is_empty():
			full_args = args.duplicate()
			full_args.append_array(extra_args)
		await callable.call(full_args)

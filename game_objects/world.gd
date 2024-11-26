class_name World extends Node2D

@export var actions : ActionList

const ON_READY : StringName = "on_ready"
const ON_PROC : StringName = "on_process"

func _ready() -> void:
	actions.run_event(ON_READY)

func _process(_delta: float) -> void:
	actions.run_event(ON_PROC)

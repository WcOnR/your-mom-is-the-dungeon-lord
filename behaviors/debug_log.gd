class_name DebugLog extends RefCounted


func on_ready(args : Array[Variant]) -> bool:
	print("[on_ready] ", args[0])
	return false


func on_process(args : Array[Variant]) -> bool:
	print("[on_process] ", args[0])
	return false

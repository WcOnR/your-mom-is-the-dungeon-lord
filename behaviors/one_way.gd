class_name OneWay extends RefCounted

func on_process(args : Array[Variant]) -> bool:
	print("[it doesn't meter] ", args[0])
	return true

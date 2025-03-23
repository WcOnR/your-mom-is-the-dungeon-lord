class_name ConsumablePanel extends Control

@onready var holders : Array[ConsumableItemHolder] = [$ConsumableItemHolder, $ConsumableItemHolder2, $ConsumableItemHolder3]

signal begin_hold


func _ready() -> void:
	for h in holders:
		h.begin_hold.connect(_on_begin_hold)


func _on_begin_hold() -> void:
	begin_hold.emit()

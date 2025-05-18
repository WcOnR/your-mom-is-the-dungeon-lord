class_name StatisticsPanel extends Container

@onready var info_container := %InfoContainer
@onready var coin_panel := %CoinPanel
@onready var info_scene : PackedScene = preload("res://ui/phone/statistics_panel/statistics_panel_info.tscn")


func show_info(info : Array[StatisticsInfo], total : int, inventory : InventoryComp) -> void:
	var cur := inventory.get_currency_pack()
	coin_panel.show_amount(cur.count)
	await get_tree().create_timer(0.3).timeout
	var timer := Timer.new()
	timer.autostart = true
	timer.wait_time = 0.1
	add_child(timer)
	var container : BoxContainer = %InfoContainer
	for i in info.size():
		var item := info_scene.instantiate() as StatisticsPanelInfo
		item.set_info(info[i], i % 2)
		container.add_child(item)
		await timer.timeout
	timer.queue_free()
	await get_tree().create_timer(0.4).timeout
	%TotalAmount.text = "%d H" % total
	%TotalAmount.visible = true
	await get_tree().create_timer(0.4).timeout
	var tween := get_tree().create_tween()
	tween.tween_method(_on_tween, cur.count, cur.count + total, 1.0)


func _on_tween(amount : int) -> void:
	coin_panel.show_amount(amount)

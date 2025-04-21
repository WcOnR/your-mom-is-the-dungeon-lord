class_name StatisticsPanel extends Container

@onready var info_container := %InfoContainer
@onready var coin_panel := %CoinPanel
@onready var info_scene : PackedScene = preload("res://ui/phone/statistics_panel/statistics_panel_info.tscn")


func show_info(info : Array[StatisticsInfo], inventory : InventoryComp) -> void:
	var container : BoxContainer = %InfoContainer
	for i in info:
		var item := info_scene.instantiate() as StatisticsPanelInfo
		item.set_info(i)
		container.add_child(item)
	var cur := inventory.get_currency_pack()
	coin_panel.show_amount(cur.count)

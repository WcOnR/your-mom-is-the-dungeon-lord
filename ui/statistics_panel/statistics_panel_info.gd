class_name StatisticsPanelInfo extends HBoxContainer


func set_info(info : StatisticsInfo) -> void:
	$Name.text = info.name
	$Multiplier.text = "x%d" % info.count
	$Coins.text = "%d H" % info.score

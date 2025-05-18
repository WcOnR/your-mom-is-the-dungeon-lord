class_name StatisticsPanelInfo extends Control


func set_info(info : StatisticsInfo, show_bg : bool) -> void:
	%BgPanel.modulate = Color(Color.WHITE, 0.7 if show_bg else 0.3)
	%Name.text = info.name
	if info.is_multiplayer:
		%Multiplier.visible = false
		%Coins.text = "x%d" % info.count
	else:
		%Multiplier.text = "x%d" % info.count
		%Coins.text = "%d H" % info.score

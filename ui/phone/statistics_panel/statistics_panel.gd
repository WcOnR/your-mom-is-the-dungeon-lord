class_name StatisticsPanel extends Container

@export var info_sound : AudioData = null
@export var coin_count_sound : AudioData = null

@onready var info_container := %InfoContainer
@onready var coin_panel := %CoinPanel
@onready var info_scene : PackedScene = preload("res://ui/phone/statistics_panel/statistics_panel_info.tscn")

var coin_sound_handel : AudioStreamPlayer = null


func _ready() -> void:
	var phone := get_tree().get_first_node_in_group("Phone") as Phone
	var home_btn := phone.get_home_btn()
	home_btn.pressed.connect(_on_cancel_coin_sond)


func show_info(info : Array[StatisticsInfo], total : int, inventory : InventoryComp) -> void:
	var cur := inventory.get_currency_pack()
	coin_panel.show_amount(cur.count)
	await get_tree().create_timer(0.3).timeout
	if not visible:
		return
	
	var timer := Timer.new()
	timer.autostart = true
	timer.wait_time = 0.1
	add_child(timer)
	var container : BoxContainer = %InfoContainer
	for i in info.size():
		var item := info_scene.instantiate() as StatisticsPanelInfo
		item.set_info(info[i], i % 2)
		container.add_child(item)
		SoundSystem.play_sound(info_sound)
		await timer.timeout
		if not visible:
			timer.queue_free()
			return
	timer.queue_free()
	await get_tree().create_timer(0.4).timeout
	if not visible:
		return
	
	SoundSystem.play_sound(info_sound)
	%TotalAmount.text = "%d H" % total
	%TotalAmount.visible = true
	await get_tree().create_timer(0.4).timeout
	if not visible:
		return
	
	var time := 1.0
	var tween := get_tree().create_tween()
	tween.tween_method(_on_tween, cur.count, cur.count + total, time)
	coin_sound_handel = SoundSystem.play_sound(coin_count_sound, time)


func _on_cancel_coin_sond() -> void:
	if coin_sound_handel != null:
		coin_sound_handel.stop()
		coin_sound_handel = null


func _on_tween(amount : int) -> void:
	coin_panel.show_amount(amount)

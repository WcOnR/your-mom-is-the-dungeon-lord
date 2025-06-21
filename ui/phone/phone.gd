class_name Phone extends Node2D

enum State {BATTLE, SHOP, BONUS}

@export var state : State = State.BATTLE

@onready var battle_hub : BattleHUD = %BattleHUD
@onready var settings_panel : Container = %SettingsPanel

@onready var equipment_panel : EquipmentPanel = %EquipmentPanel
@onready var statistics_panel : StatisticsPanel = %StatisticsPanel
@onready var item_loot_panel : ItemLootPanel = %ItemLootPanel
@onready var equip_loot_panel : EquipLootPanel = %EquipLootPanel
@onready var restart_panel : RestartPanel = %RestartPanel

@onready var back_button : Button = %BackButton
@onready var home_button : HomeBtn = %HomeBtn
@onready var pause_button : TextureButton = %PauseBtn


const CENTER_POS := Vector2(960, 500)


signal panel_changed


var init_pos : Vector2
var main_screen : Control = null
var panel_stack : Array[Control] = []


func _ready() -> void:
	init_pos = position
	back_button.pressed.connect(_on_back_button_pressed)
	pause_button.pressed.connect(_on_pause_button_pressed)
	if state == State.BONUS:
		position = position + Vector2(800, 1200)
	else:
		position = position + Vector2(50, 400)
		start_show_anim()
	GameInputManagerSystem.on_click_start.connect(_on_click_action)


func start_show_anim() -> void:
	_pre_anim_init()
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "position", init_pos, 0.5)
	await get_tree().create_timer(0.75).timeout
	%ScreenLight.visible = true
	%PhoneScreen.modulate = Color(Color.WHITE, 0.2)
	await get_tree().create_timer(0.2).timeout
	%ScreenUI.visible = true


func move_to_center() -> void:
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "position", CENTER_POS, 1.0)


func get_home_btn() -> HomeBtn:
	return %HomeBtn


func get_equipment_panel() -> EquipmentPanel:
	return equipment_panel


func get_battle_hub() -> BattleHUD:
	return battle_hub


func get_statistics_panel() -> StatisticsPanel:
	return statistics_panel


func get_item_loot_panel() -> ItemLootPanel:
	return item_loot_panel


func get_equip_loot_panel() -> EquipLootPanel:
	return equip_loot_panel


func get_restart_panel() -> RestartPanel:
	return restart_panel


func set_main_screen(panel : Control) -> void:
	if main_screen == null:
		_set_visible_panel(panel, true)
		main_screen = panel
	elif panel != main_screen:
		var old_panel := main_screen
		_set_visible_panel(old_panel, false)
		_set_visible_panel(panel, true)
		main_screen = panel
		panel_changed.emit()
		while not panel_stack.is_empty():
			pop_top_panel()


func add_to_panel_stack(panel : Control) -> void:
	if panel_stack.is_empty():
		_set_visible_panel(main_screen, false)
	else:
		if panel_stack[-1] == panel:
			return
		_set_visible_panel(panel_stack[-1], false)
	_set_visible_panel(panel, true)
	panel_stack.append(panel)
	panel_changed.emit()
	_update_back_button()


func get_top_panel() -> Control:
	if not panel_stack.is_empty():
		return panel_stack[-1]
	return null


func pop_top_panel() -> void:
	if not panel_stack.is_empty():
		_set_visible_panel(panel_stack[-1], false)
		panel_stack.remove_at(panel_stack.size() - 1)
	if panel_stack.is_empty():
		_set_visible_panel(main_screen, true)
	else:
		_set_visible_panel(panel_stack[-1], true)
	panel_changed.emit()
	_update_back_button()


func _set_visible_panel(panel : Control, vis : bool) -> void:
	panel.visible = vis
	if panel is BattleHUD and state == State.BATTLE:
		var game_mode := get_tree().get_first_node_in_group("GameMode") as BattleGameMode
		battle_hub.enable_input(vis and game_mode.turns_left() > 0)


func _on_click_action(data : ClickData) -> void:
	var screen_rect : Rect2 = %ScreenUI.get_rect()
	screen_rect.position = screen_rect.position + global_position
	if screen_rect.intersects(Rect2(data.start_position, Vector2.ONE)):
		var tap := SettingsManager.get_settings().sounds.tap
		SoundSystem.play_sound(tap)


func _on_back_button_pressed() -> void:
	pop_top_panel()


func _on_pause_button_pressed() -> void:
	var click := SettingsManager.get_settings().sounds.click
	SoundSystem.play_sound(click)
	if not panel_stack.is_empty() and panel_stack[-1] == settings_panel:
		pop_top_panel()
		return
	add_to_panel_stack(settings_panel)


func _update_back_button() -> void:
	back_button.visible = not panel_stack.is_empty()
	home_button.set_main_state(panel_stack.is_empty())


func _pre_anim_init() -> void:
	match state:
		State.BONUS:
			var game_mode := get_tree().get_first_node_in_group("GameMode") as BonusGameMode
			item_loot_panel.set_reward_view(game_mode.get_rewards()[0]) #TODO:: rework rewards
			set_main_screen(item_loot_panel)
		State.BATTLE:
			var game_mode := get_tree().get_first_node_in_group("GameMode") as BattleGameMode
			game_mode.set_phone(self)
		State.SHOP:
			set_main_screen(item_loot_panel)
			var game_mode := get_tree().get_first_node_in_group("GameMode") as ShopGameMod
			game_mode.set_phone(self)

@tool
class_name EquipHint extends MarginContainer

@export var name_alligment : HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER:
	set(new_alligment):
		name_alligment = new_alligment
		%NameContainer.alignment = new_alligment
		if new_alligment == HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT:
			%Extander.visible = false

@export var info_btn_show : bool = true:
	set(new_val):
		info_btn_show = new_val
		%InfoButton.visible = new_val
		%Extander.visible = new_val


@onready var description_label : RichTextLabel = %DescriptionLabel
@onready var story_label : Label = %StoryLabel


signal info_toggled(bool)


func _ready() -> void:
	%InfoButton.pressed.connect(_on_info_toggle)


func clear() -> void:
	%EmptySlot.visible = false
	%HintContainer.visible = false


func set_equip(pack : ItemPack, is_reward : bool) -> void:
	if pack and pack.item_preset:
		var hint_text : String = ""
		var settings := SettingsManager.get_settings()
		if is_reward:
			hint_text = settings.get_reward_equip_hint(pack)
		else:
			hint_text = settings.get_equip_hint(pack)
		%NameLabel.text = pack.item_preset.item_name
		description_label.text = hint_text
		story_label.text = pack.item_preset.story_description
		%EmptySlot.visible = false
		%HintContainer.visible = true
	else:
		%EmptySlot.visible = true
		%HintContainer.visible = false


func set_item(item_preset : ItemPreset) -> void:
	%NameLabel.text = item_preset.item_name
	description_label.text = item_preset.item_description
	story_label.text = item_preset.story_description
	%EmptySlot.visible = false
	%HintContainer.visible = true


func _on_info_toggle() -> void:
	description_label.visible = not description_label.visible
	story_label.visible = not story_label.visible
	info_toggled.emit(story_label.visible)

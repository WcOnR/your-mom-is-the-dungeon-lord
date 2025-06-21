@tool
class_name EquipHint extends MarginContainer

@export var name_alligment : HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER:
	set(new_alligment):
		name_alligment = new_alligment
		%NameLabel.horizontal_alignment = new_alligment

@onready var description_label : RichTextLabel = $HintContainer/DescriptionLabel

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
		%EmptySlot.visible = false
		%HintContainer.visible = true
	else:
		%EmptySlot.visible = true
		%HintContainer.visible = false


func set_item(item_preset : ItemPreset) -> void:
	%NameLabel.text = item_preset.item_name
	description_label.text = item_preset.item_description
	%EmptySlot.visible = false
	%HintContainer.visible = true

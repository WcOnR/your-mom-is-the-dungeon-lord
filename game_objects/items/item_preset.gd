class_name ItemPreset extends Resource

enum Type {CONSUMABL, BOOSTER, EQUIP, SUPER_EQUIP}

@export var type : Type = Type.EQUIP
@export var texture : Texture2D = null
@export var action : Action = null
@export var item_name : String = ""
@export var item_description : String = ""
@export_multiline var story_description : String = ""
@export var price : int = 100


func is_equip() -> bool:
	return type == Type.EQUIP or type == Type.SUPER_EQUIP

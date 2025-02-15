class_name ItemPreset extends Resource

enum Type {CONSUMABL, BOOSTER, EQUIP, SUPER_EQUIP}

@export var type : Type = Type.EQUIP
@export var texture : Texture2D = null
@export var action : Action = null
@export var item_name : String = ""
@export var item_description : String = ""


func create_hint(node : Node) -> Hint:
	return Hint.new(item_name, item_description, node)

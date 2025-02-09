class_name ItemPreset extends Resource

enum Type {CONSUMABL, BOOSTER, EQUIP, SUPER_EQUIP}

@export var type : Type = Type.EQUIP
@export var texture : Texture2D = null
@export var action : Action = null

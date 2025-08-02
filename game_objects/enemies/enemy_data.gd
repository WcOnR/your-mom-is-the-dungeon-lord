class_name EnemyData extends Resource

@export var name : String = ""
@export var max_health := 100
@export var damage := 10
@export var reward := 100
@export var is_boss := false
@export var actions : Array[BattleAction] = [] 
@export var behavior : Behavior = null
@export var texture : Texture2D = null
@export var hit_sound : AudioData = null

class_name EnemyData extends Resource

@export var name : String = ""
@export var max_health := 100
@export var damage := 10
@export var reward := 100
@export var actions : Array[Action] = [] 
@export var behavior : AIBehavior = null
@export var texture : Texture2D = null

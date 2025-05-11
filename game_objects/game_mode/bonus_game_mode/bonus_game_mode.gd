class_name BonusGameMode extends Node

@export var bonuies : Array[ItemPreset] = []
@export var phone : NodePath


var _reward : Array[ItemPack] = []
var _player : Player = null


func _ready() -> void:
	for b in bonuies:
		var pack : ItemPack = ItemPack.new(b)
		pack.count = 1
		_reward.append(pack)
	_player = get_tree().get_first_node_in_group("Player") as Player


func get_rewards() -> Array[ItemPack]:
	return _reward


func pick_up_done() -> void:
	var _phone := get_node(phone) as Phone
	var btn := _phone.get_home_btn()
	btn.set_state(HomeBtn.State.ACTIVE)
	btn.pressed.connect(finish_room)
	btn.set_icon(1)
	_phone.start_show_anim()


func finish_room() -> void:
	for r in _reward:
		_player.inventory_comp.add_pack(r)
	SceneLoaderSystem.unload_room()

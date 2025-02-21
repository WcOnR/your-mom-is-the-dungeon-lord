class_name BonusGameMode extends Node

@export var bonuies : Array[ItemPreset] = []
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


func finish_room() -> void:
	for r in _reward:
		_player.inventory_comp.add_pack(r)
	SceneLoaderSystem.unload_room()

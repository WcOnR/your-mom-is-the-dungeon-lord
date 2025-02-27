class_name ShopGameMod extends Node

var _player : Player = null


func get_shop_items() -> Array[ItemPack]:
	_player = get_tree().get_first_node_in_group("Player") as Player
	return $RewardCalculator.get_shop_items(_player.inventory_comp)


func finish_room() -> void:
	SceneLoaderSystem.unload_room()

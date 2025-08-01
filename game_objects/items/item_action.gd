class_name ItemAction extends Resource


func on_pick_up(_initiator : Node) -> void:
	pass


func on_battle_start(_player : Player, _level : int) -> void:
	pass


func on_attack_applied(_player : Player, _level : int) -> void:
	pass


func on_player_turn_start(_player : Player, _level : int) -> void:
	pass


func on_enemies_turn_start(_player : Player, _level : int) -> void:
	pass


func on_enemies_turn_end(_player : Player, _level : int) -> void:
	pass


func on_move(_field : Field, _id : Vector2i, _offset : Vector2) -> void:
	pass


func on_drop(_field : Field, _id : Vector2i, _offset : Vector2) -> void:
	pass

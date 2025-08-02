class_name BossSpawnAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/spawn.png")
const LEFT_TENTACLE : EnemyData = preload("res://game_objects/enemies/tentacle/e_tentacle_left.tres")
const RIGHT_TENTACLE : EnemyData = preload("res://game_objects/enemies/tentacle/e_tentacle_right.tres")


func on_plan(_enemy : Enemy, line : BattleLine) -> void:
	line.set_action(0, ICON, true)


func on_action(enemy : Enemy, _player : Player) -> void:
	var holder := enemy.get_tree().get_first_node_in_group("LineHolder") as LineHolder
	holder.spawn_enemy_on_line(LEFT_TENTACLE, 0)
	holder.spawn_enemy_on_line(RIGHT_TENTACLE, 2)

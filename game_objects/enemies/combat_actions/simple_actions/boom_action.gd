class_name BoomAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/boom.png")


func on_plan(enemy : Enemy, line : BattleLine) -> void:
	var base_attack : int = enemy.enemy_data.damage
	line.set_action(base_attack, ICON)


func on_action(enemy : Enemy, player : Player) -> void:
	var base_attack : int = enemy.enemy_data.damage
	var targets : Array[HealthComp] = [player.health_comp]
	var line_holder := enemy.get_tree().get_first_node_in_group("LineHolder") as LineHolder
	targets.append_array(line_holder.get_front_enemy_health_comp())
	for health_comp in targets:
		health_comp.apply_damage(base_attack)

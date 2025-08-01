class_name GetArmorAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/shield.png")


func on_plan(enemy : Enemy, line : BattleLine) -> void:
	var base_attack : int = enemy.enemy_data.damage
	line.set_action(base_attack * 2, ICON)


func on_action(enemy : Enemy, _player : Player) -> void:
	var base_attack : int = enemy.enemy_data.damage
	enemy.health_comp.add_shield(base_attack * 2)

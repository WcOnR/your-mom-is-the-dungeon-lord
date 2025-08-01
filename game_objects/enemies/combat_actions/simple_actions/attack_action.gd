class_name AttackAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/sword.png")


func on_plan(enemy : Enemy, line : BattleLine) -> void:
	var base_attack : int = enemy.enemy_data.damage
	line.set_action(base_attack, ICON)


func on_action(enemy : Enemy, player : Player) -> void:
	var base_attack : int = enemy.enemy_data.damage
	player.health_comp.apply_damage(base_attack)

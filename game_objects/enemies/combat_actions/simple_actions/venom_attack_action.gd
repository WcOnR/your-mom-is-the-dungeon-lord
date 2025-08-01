class_name VenomAttackAction extends BattleAction

const ICON : Texture2D = preload("res://ui/action_icons/venom.png")


func on_plan(enemy : Enemy, line : BattleLine) -> void:
	var base_attack : int = enemy.enemy_data.damage
	line.set_action(base_attack, ICON)


func on_action(enemy : Enemy, _player : Player) -> void:
	var attack_comp := enemy.attack_comp
	attack_comp.shield_penetration_bonus = 0.0001
	attack_comp.attack(enemy.enemy_data.damage)

class_name PopUpNumber extends Control

@export var add_setting : LabelSettings = null
@export var sub_setting : LabelSettings = null

const SCENE : PackedScene = preload("res://ui/widgets/pop_up_numbers.tscn")

static func create_pop_up(holder : Node, dif : int, pos : Vector2 = Vector2.ZERO) -> PopUpNumber:
	var popup := SCENE.instantiate() as PopUpNumber
	holder.add_child(popup)
	popup._initialize(dif, pos)
	return popup


func _initialize(dif : int, pos : Vector2) -> void:
	var lbl : Label = $Label
	if dif > 0:
		lbl.text = "+" + str(dif)
		lbl.label_settings = add_setting
	else:
		lbl.text = str(dif)
		lbl.label_settings = sub_setting
	lbl.position.x = -lbl.size.x / 2.0
	lbl.position += pos
	var curve := AnimManagerSystem.get_curve("easeOut")
	var anim := AnimObject.new(self, _anim, curve)
	AnimManagerSystem.start_anim(anim)
	await anim.anim_finished
	get_parent().remove_child(self)
	queue_free()


func _anim(t : float) -> void:
	$Label.position.y = -t * 50.0 - $Label.size.y
	$Label.self_modulate.a = t

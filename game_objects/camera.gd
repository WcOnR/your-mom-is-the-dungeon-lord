class_name GameCamera extends Camera2D

@export var hit_overlay_path : NodePath

var _noise = FastNoiseLite.new()
var _active_shake_time := 0.0
var _shake_intensity := 0.0
var _shake_time := 0.0

var _shake_time_speed := 20.0
var _shake_decay := 5.0


func _physics_process(delta: float) -> void:
	if _active_shake_time > 0.0:
		_shake_time += delta * _shake_time_speed
		_active_shake_time -= delta
		
		offset = Vector2(
			_noise.get_noise_2d(_shake_time, 0.0) * _shake_intensity,
			_noise.get_noise_2d(0.0, _shake_time) * _shake_intensity
		)
		_shake_intensity = max(_shake_intensity - _shake_decay * delta, 0.0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)


func screen_shake(intensity : float, duration : float):
	_noise.seed = randi()
	_noise.frequency = 2.0
	_shake_time = 0.0
	_active_shake_time = duration
	_shake_intensity = minf(25.0, absf(intensity))


func play_hit_anim() -> void:
	var overlay := get_node(hit_overlay_path)
	var tween := overlay.create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.01)
	tween.tween_property(overlay, "modulate:a", 0.0, 0.3)

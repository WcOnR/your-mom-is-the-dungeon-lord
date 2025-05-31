class_name SoundManager extends Node

var _players : Array[AudioStreamPlayer] = []
var _sfx_bus_id : int = -1
var _music_bus_id : int = -1

const SFX_BUS : StringName = "SFX"
const Music_BUS : StringName = "Music"


func _ready() -> void:
	_sfx_bus_id = AudioServer.get_bus_index(SFX_BUS)
	_music_bus_id = AudioServer.get_bus_index(Music_BUS)


func set_sound_volume(new_volume : float) -> void:
	AudioServer.set_bus_volume_db(_sfx_bus_id, new_volume)


func get_sound_volume() -> float:
	return AudioServer.get_bus_volume_db(_sfx_bus_id)


func set_music_volume(new_volume : float) -> void:
	AudioServer.set_bus_volume_db(_music_bus_id, new_volume)


func get_music_volume() -> float:
	return AudioServer.get_bus_volume_db(_music_bus_id)


func play_sound(data : AudioData, duration : float = -1.0) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = data.stream
	player.volume_db = data.volume_db
	player.pitch_scale = data.pitch_scale
	player.finished.connect(_sound_end.bind(player))
	player.autoplay = true
	player.bus = SFX_BUS
	_players.append(player)
	add_child(player)
	if duration > 0.0:
		get_tree().create_timer(duration).timeout.connect(stop_sound.bind(player))
	return player


func stop_sound(palyer : AudioStreamPlayer) -> void:
	palyer.stop()
	_sound_end(palyer)


func _sound_end(palyer : AudioStreamPlayer) -> void:
	_players.erase(palyer)
	palyer.queue_free()

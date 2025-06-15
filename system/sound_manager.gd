class_name SoundManager extends Node

var _players : Array[AudioStreamPlayer] = []
var _interactive_player : AudioStreamPlayer = null
var _sfx_bus_id : int = -1
var _music_bus_id : int = -1

const SFX_BUS : StringName = "SFX"
const Music_BUS : StringName = "Music"


func _ready() -> void:
	_sfx_bus_id = AudioServer.get_bus_index(SFX_BUS)
	_music_bus_id = AudioServer.get_bus_index(Music_BUS)
	SettingsManager.reg_runtime_setting("music", 50.0)
	SettingsManager.reg_runtime_setting("music_on", true)
	SettingsManager.reg_runtime_setting("sfx", 50.0)
	SettingsManager.reg_runtime_setting("sfx_on", true)
	SettingsManager.runtime_setting_changed.connect(_on_runtime_setting_changed)


func set_interactive_player(player : AudioStreamPlayer) -> void:
	_interactive_player = player


func set_bg_state(state : StringName) -> void:
	if _interactive_player == null:
		return
	var playback := _interactive_player.get_stream_playback() as AudioStreamPlaybackInteractive
	playback.switch_to_clip_by_name(state)


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


func _set_sound_volume(new_volume : float) -> void:
	var db_val := _to_db(new_volume)
	AudioServer.set_bus_volume_db(_sfx_bus_id, db_val)


func _set_sound_mute(mute : bool) -> void:
	AudioServer.set_bus_mute(_sfx_bus_id, mute)


func _set_music_volume(new_volume : float) -> void:
	var db_val := _to_db(new_volume)
	AudioServer.set_bus_volume_db(_music_bus_id, db_val)


func _set_music_mute(mute : bool) -> void:
	AudioServer.set_bus_mute(_music_bus_id, mute)


func _to_db(val : float) -> float:
	var offset := val - 50.0
	var db_val := absf(offset)
	db_val = db_val * db_val / 100.0
	return sign(offset) * db_val


func _on_runtime_setting_changed(_name : StringName) -> void:
	if _name == "music":
		_set_music_volume(SettingsManager.get_runtime_setting(_name))
	elif _name == "music_on":
		_set_music_mute(!SettingsManager.get_runtime_setting(_name))
	elif _name == "sfx":
		_set_sound_volume(SettingsManager.get_runtime_setting(_name))
	elif _name == "sfx_on":
		_set_sound_mute(!SettingsManager.get_runtime_setting(_name))

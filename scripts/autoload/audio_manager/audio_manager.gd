extends Node

## The window of time in which a perfect attack may be executed
const PERFECT_ATTACK_WINDOW: float = 0.15
## The window of time in which a perfect dash may be executed
const PERFECT_DODGE_WINDOW: float = 0.2
## The window of time in which a perfect parry may be executed
const PERFECT_PARRY_WINDOW: float = 0.1
## The window of time in which the player may recover from an attack
const PERFECT_RECOVERY_WINDOW: float = 0.15

## The prefab to instantiate when playing a one shot clip
@export var audio_player_prefab: PackedScene

## The audio stream player of the current music track, fades out to upcoming track
@onready var current_music_player: AudioStreamPlayer2D = $current_music_player
## The audio stream player of the upcoming music track, fades in from current track
@onready var upcoming_music_player: AudioStreamPlayer2D = $upcoming_music_player

## Emitted when the music reaches a downbeat
signal downbeat

## The currently playing music track
var current_track: MusicTrack

## The number of beats into the current track in the previous frame
var previous_beats_played: int
## The number of beats into the current track
var beats_played: int

## The duration of a single beat
var beat_length: float:
	get:
		if current_track == null:
			return -1
		return 60.0 / current_track.bpm

## Time to the next beat of the current song
var time_to_next_beat: float:
	get:
		if current_track == null:
			return INF
		var sec: float = current_music_player.get_playback_position()
		return beat_length - fposmod(sec, beat_length)

## Whether a perfect attack was executed
var perfect_attacked: bool:
	get:
		return time_to_next_beat < PERFECT_ATTACK_WINDOW / 2 or beat_length - time_to_next_beat < PERFECT_ATTACK_WINDOW / 2

## Whether a perfect parry was executed
var perfect_parried: bool:
	get:
		return time_to_next_beat < PERFECT_PARRY_WINDOW / 2 or beat_length - time_to_next_beat < PERFECT_PARRY_WINDOW / 2

func _process(delta: float) -> void:
	check_downbeat()

## Check whether to emit the downbeat signal
func check_downbeat() -> void:
	if current_track == null:
		return
	var sec_per_beat: float = 60.0 / current_track.bpm
	var sec: float = current_music_player.get_playback_position()
	previous_beats_played = beats_played
	beats_played = floor(sec / sec_per_beat)
	if previous_beats_played != beats_played:
		downbeat.emit()
	
## Play a one shot audio clip
func play_clip(clip: AudioStream) -> void:
	var audio_player: AudioStreamPlayer2D = audio_player_prefab.instantiate()
	audio_player.finished.connect(func(): audio_player.queue_free())
	audio_player.stream = clip
	add_child(audio_player)
	audio_player.play()

## Play a music track, fading out from the current track into the new track
func play_music(track: MusicTrack, fade_time: float = 5, immediate: bool = false) -> void:
	# Immediately play music if nothing is currently playing (or if immediate specified)
	current_track = track
	if current_music_player.stream == null or immediate:
		current_music_player.set_stream(track.music_clip)
		current_music_player.play()
		return
	# Don't fade in and out of the same music track
	elif (current_music_player.stream != null and track.music_clip.resource_path == current_music_player.stream.resource_path):
		return
	upcoming_music_player.set_stream(track.music_clip)
	upcoming_music_player.play(current_music_player.get_playback_position())
	upcoming_music_player.set_volume_db(-32)
	var volume_tween: Tween = create_tween()
	volume_tween.finished.connect(func():
		current_music_player.set_stream(track.music_clip)
		current_music_player.set_volume_db(0)
		current_music_player.play(upcoming_music_player.get_playback_position())
		upcoming_music_player.stop())
	volume_tween.tween_property(current_music_player, "volume_db", -32, fade_time).from_current().set_trans(Tween.TRANS_CUBIC)
	volume_tween.parallel().tween_property(upcoming_music_player, "volume_db", 0, fade_time).from_current().set_trans(Tween.TRANS_CUBIC)

## Stop the currently playing music
func stop_music() -> void:
	current_music_player.stop()
	current_music_player.stream = null
	upcoming_music_player.stop()
	upcoming_music_player.stream = null
	current_track = null

func _on_current_music_player_finished() -> void:
	current_music_player.play()

func _on_upcoming_music_player_finished() -> void:
	upcoming_music_player.play()

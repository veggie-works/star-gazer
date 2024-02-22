extends Node

## The prefab to instantiate when playing a one shot clip
@export var audio_player_prefab: PackedScene

## The audio stream player of the current music track, fades out to upcoming track
@onready var current_music_player: AudioStreamPlayer2D = $current_music_player
## The audio stream player of the upcoming music track, fades in from current track
@onready var upcoming_music_player: AudioStreamPlayer2D = $upcoming_music_player

## Play a one shot audio clip
func play_clip(clip: AudioStream) -> void:
	var audio_player: AudioStreamPlayer2D = audio_player_prefab.instantiate()
	audio_player.finished.connect(func(): audio_player.queue_free())
	audio_player.stream = clip
	add_child(audio_player)
	audio_player.play()

## Play a music track, fading out from the current track into the new track
func play_music(track: MusicTrack, fade_time: float = 5) -> void:
	# Immediately play music if nothing is currently playing
	if current_music_player.stream == null:
		current_music_player.set_stream(track.music_clip)
		current_music_player.play()
		return
	# Don't fade in and out of the same music track
	elif current_music_player.stream != null and track.music_clip.resource_path == current_music_player.stream.resource_path:
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

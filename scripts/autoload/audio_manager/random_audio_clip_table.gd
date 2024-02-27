## A set of clips to play at random
class_name RandomAudioClipTable extends Resource

## A list of clips to choose from
@export var clips: Array[AudioStream] = []

## Play a random clip
func play_random(pitch_min: float = 1, pitch_max: float = 1) -> void:
	AudioManager.play_clip(Globals.get_random(clips), pitch_min, pitch_max)

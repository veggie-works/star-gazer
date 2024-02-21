## Displays debug information about the game
class_name DebugPanel extends BaseUI

@onready var label: Label = $panel/label

func _process(delta) -> void:
	update_label()

## Update the label with the latest debug information
func update_label() -> void:
	var next_beat_time: float = get_time_to_next_beat()
	label.text = """
		Time to next beat: %0.3f
	""" % \
	[next_beat_time]

func get_time_to_next_beat() -> float:
	return BeatManager.time_to_next_beat

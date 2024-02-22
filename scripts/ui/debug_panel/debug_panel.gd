## Displays debug information about the game
class_name DebugPanel extends BaseUI

@onready var label: Label = $panel/label

var player_fsm: PlayerFSM:
	get:
		var players: Array[Node] = get_tree().get_nodes_in_group("players")
		if len(players) > 0 and players[0] is Player:
			return players[0].get_node("fsm")
		return null

func _process(_delta: float) -> void:
	update_label()

## Update the label with the latest debug information
func update_label() -> void:
	label.text = """
		Time to next beat: %0.3f
		%s
	""" % \
	[AudioManager.time_to_next_beat, format_state_history()]

func format_state_history() -> String:
	var history_string: String = """State History"""
	if player_fsm == null:
		return history_string
	for state in player_fsm.state_history:
		history_string += "\n%s" % state.name
	return history_string

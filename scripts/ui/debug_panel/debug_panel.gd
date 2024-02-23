## Displays debug information about the game
class_name DebugPanel extends BaseUI

## The debug panel's text label
@onready var label: Label = $panel/label

## The player instance
var player: Player:
	get:
		var players: Array[Node] = get_tree().get_nodes_in_group("players")
		if len(players) > 0 and players[0] is Player:
			return players[0]
		return null
		
## The player instance's state machine
var player_fsm: PlayerFSM:
	get:
		if player == null:
			return null
		return player.get_node("fsm")

func _process(_delta: float) -> void:
	update_label()

## Update the label with the latest debug information
func update_label() -> void:
	var coyote_time_remaining: float = 0.0 if player == null else player.coyote_timer.time_left
	var combo_counter: int = 0 if player == null else player.get_node("behaviors/combo_manager").combo_counter
	label.text = """
		Time to next beat: %0.3f
		Coyote time: %.3f
		Combo counter: %d
		%s
	""" % \
	[AudioManager.time_to_next_beat, coyote_time_remaining, combo_counter, format_state_history()]

## Create a string of the player's state history
func format_state_history() -> String:
	var history_string: String = """State History"""
	if player_fsm == null:
		return history_string
	for state in player_fsm.state_history:
		history_string += "\n%s" % state.name
	return history_string

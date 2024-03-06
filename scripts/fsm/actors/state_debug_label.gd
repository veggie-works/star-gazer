## Displays a list of the actor's associated FSM's state history
extends Label

## The FSM that this label will pull information from
@onready var fsm: StateMachine = get_node_or_null("../fsm")

func _ready() -> void:
	if fsm:
		fsm.state_changed.connect(on_state_change)
	update_label()
	
## Update the label text
func update_label() -> void:
	var state_string: String = ""
	for state in fsm.state_history:
		state_string += "%s\n" % state.name
	text = state_string
	
## Callback for when the current FSM state changes
func on_state_change(_old_state: State, _new_state: State) -> void:
	update_label()

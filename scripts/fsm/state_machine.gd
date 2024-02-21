## A finite state machine
class_name StateMachine extends Node

## The starting state of the FSM
@export var start_state: State
## The maximum capacity of the state history
@export_range(3, 10) var state_history_capacity: int = 5

## Emitted when the current state changes
signal state_changed(old_state: State, new_state: State)

## A list of the visitable states within the FSM
var states: Array[State] = []

## A list of the current and previously-visited states
var state_history: Array[State] = []

## The FSM's current state
var current_state: State

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.fsm = self
			states.append(child)
	set_state(start_state)

func _process(delta: float) -> void:
	current_state.update(delta)

## Set the FSM's current state to a new state
func set_state(new_state: State) -> void:
	var old_state: State = current_state
	if old_state != null:
		old_state.exit()
	new_state.enter()
	state_history.append(new_state)
	if len(state_history) > state_history_capacity:
		state_history.pop_front()
	state_changed.emit(old_state, new_state)
	current_state = new_state

## Transition to a new state
func transition_to(state_type: GDScript) -> void:
	set_state(get_state(state_type))

## Fetch a state by its script
func get_state(state_type: GDScript) -> State:
	var found_states: Array[State] = states.filter(func(state): return state.get_script() == state_type)
	if len(found_states) > 0:
		return found_states[0]
	printerr("Failed to find state ", state_type)
	return null

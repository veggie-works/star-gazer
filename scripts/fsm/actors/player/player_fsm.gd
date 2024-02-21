## Player-specific finite state machine
class_name PlayerFSM extends StateMachine

func _input(event: InputEvent) -> void:
	current_state.input(event)

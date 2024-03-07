## A state in a finite state machine
class_name State extends Node

## The state machine that contains this state
var fsm: StateMachine

## Runs when the state is entered
func enter() -> void:
	pass

## Runs when the state is exited
func exit() -> void:
	pass
	
## Update the state every process frame
func update(_delta: float) -> void:
	pass

## Update the state every physics frame
func fixed_update(_delta) -> void:
	pass

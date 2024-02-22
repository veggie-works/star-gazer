## Manages the direction and magnitude at which an actor recoils
class_name RecoilManager extends Node

## The actor's state machine
@export var state_machine: StateMachine
## The state at which the actor recoils
@export var recoil_state: State

## The actor body that will recoil
@onready var actor: Actor = get_owner()

## Perform a recoil
func recoil(angle: float, amount: float) -> void:
	var angle_rad: float = deg_to_rad(angle)
	var recoil_vector := Vector2(cos(angle_rad), -sin(angle_rad)) * amount
	actor.velocity = recoil_vector
	if state_machine != null and recoil_state != null:
		state_machine.set_state(recoil_state)

## Manages the direction and magnitude at which an actor recoils
class_name RecoilManager extends Node

## The state at which the actor recoils
@export var recoil_state: State

## The actor body that will recoil
@onready var actor: Actor = get_owner()

## Whether the actor is recoiling
var is_recoiling: bool:
	get:
		return recoil_state != null and recoil_state.fsm.current_state == recoil_state

## Perform a recoil
func recoil(angle: float, amount: float) -> void:
	var angle_rad: float = deg_to_rad(angle)
	var recoil_vector := Vector2(cos(angle_rad), -sin(angle_rad)) * amount
	actor.velocity = recoil_vector
	if recoil_state:
		recoil_state.fsm.set_state(recoil_state)

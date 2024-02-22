## Player recovery state
class_name PlayerRecoverState extends PlayerState

func enter() -> void:
	pass
	body.velocity = Vector2.ZERO
	#animator.play("recover")
	#await animator.animation_finished
	fsm.transition_to(PlayerFallState)

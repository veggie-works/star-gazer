## The actor idle state
class_name PlayerIdleState extends PlayerState

func enter() -> void:
	animator.play("idle")
	body.velocity.x = 0

func update(delta: float) -> void:
	if abs(Input.get_axis("move_left", "move_right")) > 0:
		fsm.transition_to(PlayerRunState)
	elif Input.is_action_just_pressed("jump") or InputManager.is_buffered("jump"):
		fsm.transition_to(PlayerJumpState)

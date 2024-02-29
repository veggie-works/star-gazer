## The actor idle state
class_name PlayerIdleState extends PlayerState

func enter() -> void:
	if abs(body.velocity.x) > 0 and body.disable_input:
		await body.arrived
		
	animator.play("idle")
	body.velocity.x = 0

func update(delta: float) -> void:
	if not body.is_grounded():
		fsm.transition_to(PlayerFallState)
		return
		
	if body.disable_input:
		return
		
	if abs(Input.get_axis("move_left", "move_right")) > 0:
		fsm.transition_to(PlayerRunState)
	elif InputManager.is_buffered("jump") or ((body.is_grounded() or body.in_coyote_time) and Input.is_action_just_pressed("jump")):
		fsm.transition_to(PlayerJumpState)

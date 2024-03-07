## The actor idle state
class_name PlayerIdleState extends PlayerState

func enter() -> void:
	if abs(body.velocity.x) > 0 and body.in_cutscene:
		while abs(body.velocity.x) > 0:
			await get_tree().process_frame
	animator.play("idle")
	body.velocity.x = 0

func update(_delta: float) -> void:
	if not body.is_grounded():
		fsm.transition_to(PlayerFallState)
		return
		
	if body.disable_input:
		if abs(body.velocity.x) > 0:
			fsm.transition_to(PlayerRunState)
		return
		
	if abs(Input.get_axis("left", "right")) > 0:
		fsm.transition_to(PlayerRunState)
	elif InputManager.is_buffered("jump") or ((body.is_grounded() or body.in_coyote_time) and Input.is_action_just_pressed("jump")):
		fsm.transition_to(PlayerJumpState)

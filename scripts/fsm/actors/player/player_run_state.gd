## Player running state
class_name PlayerRunState extends PlayerState

## The random table of clips to choose a footstep sound from
@export var footstep_clip_table: RandomAudioClipTable

func enter() -> void:
	animator.play("run")

func update(_delta: float) -> void:
	if not body.is_grounded():
		fsm.transition_to(PlayerFallState)
		return
		
	if body.disable_input:
		if abs(body.velocity.x) <= 0:
			fsm.transition_to(PlayerIdleState)
		return
		
	body.velocity.x = 0
	var direction = sign(Input.get_axis("left", "right"))
	if abs(direction) <= 0:
		fsm.transition_to(PlayerIdleState)
		return
	body.velocity.x += direction * body.run_speed
	if InputManager.is_buffered("jump") or ((body.is_grounded() or body.in_coyote_time) and Input.is_action_just_pressed("jump")):
		fsm.transition_to(PlayerJumpState)

## Play footstep SFX
func play_footstep() -> void:
	footstep_clip_table.play_random(0.85, 1.15)

## Player running state
class_name PlayerRunState extends PlayerState

## The speed that the player runs at
@export var run_speed: float = 600

func enter() -> void:
	animator.play("run")

func update(delta: float) -> void:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if abs(direction) <= 0:
		fsm.transition_to(PlayerIdleState)
		return
	body.velocity.x = direction * run_speed
	if Input.is_action_just_pressed("jump") or InputManager.is_buffered("jump"):
		fsm.transition_to(PlayerJumpState)

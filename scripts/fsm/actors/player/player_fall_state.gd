## The player falling state
class_name PlayerFallState extends PlayerState

## The speed at which the player can move midair
@export var midair_move_speed: float = 400

func enter() -> void:
	animator.play("fall")
	if Input.is_action_pressed("down"):
		body.set_collision_mask_value(8, false)

func exit() -> void:
	body.set_collision_mask_value(8, true)

func update(delta: float) -> void:
	if body.is_grounded():
		fsm.transition_to(PlayerIdleState)
		return
	
	if body.disable_input:
		return
		
	body.velocity.x = 0
	var direction = Input.get_axis("move_left", "move_right")
	body.velocity.x += direction * midair_move_speed


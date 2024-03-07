## The player falling state
class_name PlayerFallState extends PlayerState

## The speed at which the player can move midair
@export var midair_move_speed: float = 400

func enter() -> void:
	animator.play("fall")
	if Input.is_action_pressed("down"):
		body.set_collision_mask_value(Globals.PhysicsLayers.PLATFORM, false)

func exit() -> void:
	body.set_collision_mask_value(Globals.PhysicsLayers.PLATFORM, true)

func update(_delta: float) -> void:
	if body.is_grounded():
		if abs(body.velocity.x) > 0:
			fsm.transition_to(PlayerRunState)
		else:
			fsm.transition_to(PlayerIdleState)
		return
	
	if body.disable_input:
		return
		
	body.velocity.x = 0
	var direction = Input.get_axis("left", "right")
	body.velocity.x += direction * midair_move_speed


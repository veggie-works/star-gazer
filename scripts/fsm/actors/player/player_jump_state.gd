## Player jumping state
class_name PlayerJumpState extends PlayerState

## The maximum height of the player's jump, in pixels
@export var jump_height: float = 200
## The speed at which the player can move midair
@export var midair_move_speed: float = 400

func enter() -> void:
	body.jump(jump_height)
	animator.play("jump")
	body.set_collision_mask_value(Globals.PhysicsLayers.PLATFORM, false)

func exit() -> void:
	body.set_collision_mask_value(Globals.PhysicsLayers.PLATFORM, true)

func update(_delta: float) -> void:
	body.velocity.x = 0
	if body.velocity.y >= 0:
		fsm.transition_to(PlayerFallState)
		return
		
	if body.in_cutscene:
		return
		
	var direction = Input.get_axis("left", "right")
	body.velocity.x += direction * midair_move_speed
	if not Input.is_action_pressed("jump"):
		body.velocity.y = max(body.velocity.y / 2, body.velocity.y)

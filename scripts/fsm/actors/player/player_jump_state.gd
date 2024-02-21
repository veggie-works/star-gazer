## Player jumping state
class_name PlayerJumpState extends PlayerState

## The maximum height of the player's jump, in pixels
@export var jump_height: float = 200
## The speed at which the player can move midair
@export var midair_move_speed: float = 400

func _ready() -> void:
	body.landed.connect(on_body_landed)

func enter() -> void:
	body.jump(jump_height)
	# animator.play("jump")

func update(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	body.velocity.x = direction * midair_move_speed
	if not Input.is_action_pressed("jump"):
		body.velocity.y = max(body.velocity.y / 2, body.velocity.y)
	
## Callback for when the player has landed
func on_body_landed() -> void:
	fsm.transition_to(PlayerIdleState)

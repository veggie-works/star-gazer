## The player falling state
class_name PlayerFallState extends PlayerState

## The speed at which the player can move midair
@export var midair_move_speed: float = 400

func _ready() -> void:
	body.landed.connect(on_body_landed)

func enter() -> void:
	pass
	# animator.play("fall")

func update(delta: float) -> void:
	if body.disable_input:
		return
		
	body.velocity.x = 0
	var direction = Input.get_axis("move_left", "move_right")
	body.velocity.x += direction * midair_move_speed
	
	if body.in_coyote_time and Input.is_action_just_pressed("jump"):
		fsm.transition_to(PlayerJumpState)

## Callback for when the player has landed
func on_body_landed() -> void:
	fsm.transition_to(PlayerIdleState)

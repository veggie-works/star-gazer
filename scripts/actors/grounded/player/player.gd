## Base class for all player characters
class_name Player extends GroundedActor

## Timer that counts down the time the player may still jump while in the air after walking off a ledge
@onready var coyote_timer: Timer = $timers/coyote_timer;

## Whether the player is still in coyote time
var in_coyote_time: bool:
	get:
		return not coyote_timer.is_stopped()

func _process(delta: float) -> void:
	update_coyote_time()
	update_jump()
	update_land()
	update_movement_inputs()
	super._process(delta)

## Update whether coyote time should start
func update_coyote_time() -> void:
	if was_grounded and not is_grounded() and velocity.y >= 0 and not InputManager.is_buffered("jump"):
		coyote_timer.start()

## Update the player jump
func update_jump() -> void:
	if InputManager.is_buffered("jump") and (is_grounded() or in_coyote_time):
		coyote_timer.stop()
		jump()

	if not Input.is_action_pressed("jump"):
		velocity.y = max(0, velocity.y)

## Update whether the player has landed on the ground
func update_land() -> void:
	if is_grounded() and not was_grounded:
		land()
		coyote_timer.stop()

## Check for movement inputs and move the player accordingly
func update_movement_inputs() -> void:
	var direction = Input.get_axis("move_left", "move_right")
	move(direction)

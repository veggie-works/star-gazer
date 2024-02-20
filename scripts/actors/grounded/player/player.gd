## Base class for all player characters
class_name Player extends GroundedActor

## Timer that counts down the time the player may still jump while in the air after walking off a ledge
@onready var coyote_timer: Timer = $timers/coyote_timer
## The area that triggers a door to start a scene transition
@onready var door_trigger_collider: CollisionShape2D = $triggers/door_trigger/collision

## Whether input should be disabled
var disable_input: bool

## Whether the player is currently in a cutscene
var in_cutscene: bool:
	set(value):
		disable_input = value
		door_trigger_collider.set_deferred("disabled", value)
		

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
	if disable_input:
		return
		
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
	if disable_input:
		return
		
	var direction = Input.get_axis("move_left", "move_right")
	move(direction)

## Base class for all player characters
class_name Player extends GroundedActor

## Controls the player's animations
@onready var anim: AnimationPlayer = $animator
## Timer that counts down the time the player may still jump while in the air after walking off a ledge
@onready var coyote_timer: Timer = $timers/coyote_timer
## Parent of areas that trigger certain objects
@onready var triggers: Node2D = $triggers

## Whether input should be disabled
var disable_input: bool

## Whether the player is currently in a cutscene
var in_cutscene: bool:
	set(value):
		disable_input = value
		for child in triggers.get_children():
			var grandchild: Node2D = child.get_child(0)
			if grandchild is CollisionShape2D:
				grandchild.set_deferred("disabled", value)

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
	update_animation()

## Update the player's current animation
func update_animation() -> void:
	if abs(velocity.x) > 0:
		anim.play("run")
	else:
		anim.play("idle")

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
		coyote_timer.stop()
	super.update_land()

## Check for movement inputs and move the player accordingly
func update_movement_inputs() -> void:
	if disable_input:
		return
		
	var direction = Input.get_axis("move_left", "move_right")
	move(direction)

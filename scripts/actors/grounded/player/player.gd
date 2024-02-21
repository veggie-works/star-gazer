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
	super._process(delta)

func _input(event: InputEvent) -> void:
	check_perfect_inputs(event)

## Check whether a perfect input has been executed
func check_perfect_inputs(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if BeatManager.time_to_next_beat <= BeatManager.PERFECT_ATTACK_WINDOW:
			pass # TODO: perfect attack
		else:
			pass # TODO: normal attack
	elif event.is_action_pressed("dash"):
		if BeatManager.time_to_next_beat <= BeatManager.PERFECT_DASH_WINDOW:
			pass # TODO: perfect dash
		else:
			pass # TODO: normal dash

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

## Update whether the player has landed on the ground
func update_land() -> void:
	if is_grounded() and not was_grounded:
		coyote_timer.stop()
	super.update_land()

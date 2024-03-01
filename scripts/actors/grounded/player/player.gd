## Base class for all player characters
class_name Player extends GroundedActor

## Controls the player's animations
@onready var anim: AnimationPlayer = $animator
## Timer that counts down the time the player may still jump while in the air after walking off a ledge
@onready var coyote_timer: Timer = $timers/coyote_timer
## Parent of areas that trigger certain objects
@onready var colliders: Array[CollisionShape2D] = []

## Whether input should be disabled
var disable_input: bool

## Whether the player is currently in a cutscene
var in_cutscene: bool:
	set(value):
		disable_input = value
		for collider: CollisionShape2D in colliders:
			collider.set_deferred("disabled", value)

## Whether the player is still in coyote time
var in_coyote_time: bool:
	get:
		return not coyote_timer.is_stopped()

func _ready() -> void:
	UIManager.get_ui(HUD).update_health()
	for collider: CollisionShape2D in find_children("*", "CollisionShape2D"):
		if collider.shape is RectangleShape2D:
			collider.global_position = collision.global_position
			collider.shape.set_size(collision.shape.size)
		colliders.append(collider)

func _process(delta: float) -> void:
	update_coyote_time()
	if Input.is_action_just_pressed("dodge"):
		$behaviors/after_image_manager.start_creating_after_images()
	super._process(delta)

## Update whether coyote time should start
func update_coyote_time() -> void:
	if was_grounded and not is_grounded() and velocity.y >= 0 and not InputManager.is_buffered("jump"):
		coyote_timer.start()
	elif is_grounded() and not was_grounded and in_coyote_time:
		coyote_timer.stop()

## Base class for all player characters
class_name Player extends GroundedActor

## Controls the player's animations
@onready var anim: AnimationPlayer = $animator
## Timer that counts down the time the player may still jump while in the air after walking off a ledge
@onready var coyote_timer: Timer = $timers/coyote_timer
## Parent of areas that trigger certain objects
@onready var colliders: Array[CollisionShape2D] = []
## The player's health manager
@onready var health_manager: HealthManager = $behaviors/health_manager

## Whether input should be disabled
var disable_input: bool

## Backing field for the in_cutscene variable
var _in_cutscene_backing_field: bool

## Whether the player is currently in a cutscene
var in_cutscene: bool:
	get:
		return _in_cutscene_backing_field
	set(value):
		_in_cutscene_backing_field = value
		disable_input = value
		for collider: CollisionShape2D in colliders:
			collider.set_deferred("disabled", value)

## Whether the player is still in coyote time
var in_coyote_time: bool:
	get:
		return not coyote_timer.is_stopped()

func _ready() -> void:
	for collider: CollisionShape2D in find_children("*", "CollisionShape2D"):
		if collider == collision:
			continue
		if collider.shape is RectangleShape2D:
			collider.global_position = collision.global_position
			collider.shape.set_size(collision.shape.size)
		colliders.append(collider)
	health_manager.current_health = SaveManager.save_data.current_health
	health_manager.max_health = SaveManager.save_data.max_health
	health_manager.took_damage.connect(on_health_manager_take_damage)
	health_manager.healed.connect(on_health_manager_healed)
	UIManager.get_ui(HUD).update_health()

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

## Callback for when the player takes damage
func on_health_manager_take_damage(_attack: Attack) -> void:
	SaveManager.save_data.current_health = health_manager.current_health
	SaveManager.save_data.max_health = health_manager.max_health

## Callback for when the player heals
func on_health_manager_healed(_amount: float) -> void:
	SaveManager.save_data.current_health = health_manager.current_health
	SaveManager.save_data.max_health = health_manager.max_health

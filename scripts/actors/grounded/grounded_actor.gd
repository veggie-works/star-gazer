## Base class for grounded actors
class_name GroundedActor extends Actor

## The scale of gravity applied to this actor
@export var gravity_scale: float = 4
## The maximum height of the actor's jump, in pixels
@export var jump_height: float = 200
## The speed at which this actor runs, in pixels per second
@export var run_speed: float = 600

## Parent node of raycasts used to detect the ground
@onready var ground_raycasts: Node2D = $ground_raycasts

## Emitted when the actor lands
signal landed
## Emitted when the actor arrives at the location it was instructed to move to
signal arrived

## The project setting's gravity value
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

## Whether the actor was grounded in the previous frame
var was_grounded: bool

func _ready() -> void:
	for child in ground_raycasts.get_children():
		if child is RayCast2D:
			child.add_exception(self)

func _process(delta: float) -> void:
	apply_gravity(delta)
	super._process(delta)
	was_grounded = is_grounded()

## Apply gravity to the actor
func apply_gravity(delta: float) -> void:
	if not is_grounded():
		velocity.y += gravity * gravity_scale * delta

## Check if the actor is grounded
func is_grounded() -> bool:
	for child in ground_raycasts.get_children():
		if child is RayCast2D and child.is_colliding():
			return true
	return false

## Perform a jump
func jump() -> void:
	velocity.y = -sqrt(2 * gravity * gravity_scale * jump_height);

## Perform a land
func land() -> void:
	landed.emit()

## Move the actor in the given horizontal direction
func move(direction: float) -> void:
	velocity.x = direction * run_speed

## Move to a target x position
func move_to(target_x: float) -> void:
	move(sign(target_x - global_position.x))
	while not abs(global_position.x - target_x) <= 1:
		if not is_inside_tree():
			break
		await get_tree().process_frame
	arrived.emit()

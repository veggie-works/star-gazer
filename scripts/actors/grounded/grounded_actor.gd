## Base class for grounded actors
class_name GroundedActor extends Actor

## The normal scale of gravity applied to this actor
@export var gravity_scale: float = 4
## The scale of gravity applied to this actor while they are falling
@export var falling_gravity_scale: float = 8
## The speed at which this actor runs, in pixels per second
@export var run_speed: float = 600
@export var terminal_velocity: float = 600

## Parent node of raycasts used to detect the ground
@onready var ground_raycasts: Node2D = $ground_raycasts

## Whether or not this actor is currently touching a wall
@onready var wall_raycasts: Node2D = $wall_raycasts

## Emitted when the actor lands
signal landed
## Emitted when the actor arrives at the location it was instructed to move to
signal arrived

## Whether the actor was grounded in the previous frame
var was_grounded: bool

func _ready() -> void:
	for child in ground_raycasts.get_children():
		if child is RayCast2D:
			child.add_exception(self)

func _process(delta: float) -> void:
	apply_gravity(delta)
	update_land()
	super._process(delta)
	was_grounded = is_grounded()

## Apply gravity to the actor
func apply_gravity(delta: float) -> void:
	if not is_grounded():
		velocity.y += Globals.gravity * (falling_gravity_scale if velocity.y >= 0 else gravity_scale) * delta
		velocity.y = min(velocity.y, terminal_velocity)

## Check if the actor is grounded
func is_grounded() -> bool:
	for child in ground_raycasts.get_children():
		if child is RayCast2D and child.is_colliding():
			return true
	return false

## Check if the actor is colliding with a wall
func is_colliding_with_wall() -> bool:
	for child in wall_raycasts.get_children():
		if child is RayCast2D and child.is_colliding():
			return true
	return false


## PAerform a jump
func jump(height: float) -> void:
	velocity.y = -sqrt(2 * Globals.gravity * gravity_scale * height);

## Jump from the actor's starting position to a target position
func jump_to(target_position: Vector2, apex_height: float, jump_time: float) -> void:
	var diff = target_position - global_position
	velocity.x = diff.x / jump_time
	var rising_gravity: float = Globals.gravity * gravity_scale
	var falling_gravity: float = Globals.gravity * falling_gravity_scale
	var final_velocity_y: float = sqrt(abs(2 * falling_gravity * (diff.y - apex_height)))
	print("Final Y: ", final_velocity_y)
	var denom_term1: float = final_velocity_y / rising_gravity
	var denom_term2: float = (2 * (diff.y - apex_height)) / final_velocity_y
	velocity.y = sqrt(2 * rising_gravity * apex_height)
	print("Velocity: ", velocity)
	await landed
	velocity.x = 0

## Perform a land
func land() -> void:
	landed.emit()

## Have the actor run in the given horizontal direction
func run(direction: float) -> void:
	move(Vector2(direction * run_speed, 0))

## Move to a target x position
func move_to(target_x: float) -> void:
	var direction = sign(target_x - global_position.x)
	run(direction)
	while (direction < 0 and global_position.x > target_x) or \
		(direction > 0 and global_position.x < target_x):
		if not is_inside_tree():
			break
		await get_tree().process_frame
	arrived.emit()

## Update the actor's landing state
func update_land() -> void:
	if not was_grounded and is_grounded():
		land()

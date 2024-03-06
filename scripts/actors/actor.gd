## Base class for all actors, e.g players, enemies, NPCs
class_name Actor extends CharacterBody2D

## The collider for the actor body
@onready var collision: CollisionShape2D = $collision
## Recoil manager to check when facing an object
@onready var recoil_manager: RecoilManager = get_node_or_null("behaviors/recoil_manager")

func _process(_delta: float) -> void:
	move_and_slide()
	if abs(velocity.x) > 0:
		if recoil_manager and recoil_manager.is_recoiling:
			return
		update_direction()

## Face an object
func face(target: Node2D) -> void:
	var self_x: float = global_position.x
	var tgt_x: float = target.global_position.x
	var scale_x: float = transform.x.x
	if self_x > tgt_x and scale_x > 0 or self_x < tgt_x and scale_x < 0:
		flip()

## Flip the actor's scale
func flip() -> void:
	transform.x.x *= -1

## Move the actor
func move(move_vector: Vector2) -> void:
	velocity = move_vector

## Update the direction that the actor is facing
func update_direction() -> void:
	var vel_x: float = velocity.x
	var scale_x: float = transform.x.x
	if vel_x < 0 and scale_x > 0 or vel_x > 0 and scale_x < 0:
		flip()

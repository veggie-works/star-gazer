## Base class for all actors, e.g players, enemies, NPCs
class_name Actor extends CharacterBody2D

## The collider for the actor body
@onready var collision: CollisionShape2D = $collision

func _process(_delta: float) -> void:
	update_direction()
	move_and_slide()

## Flip the actor's scale
func flip() -> void:
	transform.x.x *= -1

## Move the actor
func move(move_vector: Vector2) -> void:
	velocity = move_vector

## Update the direction that the actor is facing
func update_direction() -> void:
	if velocity.x < 0 and transform.x.x > 0 or velocity.x > 0 and transform.x.x < 0:
		flip()

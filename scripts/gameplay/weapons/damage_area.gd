## An area whose hitbox causes damage to an actor
class_name DamageArea extends Attack

## The animation player that controls the damager's animation
@onready var animator: AnimationPlayer = $animator

func attack() -> void:
	animator.play("attack")

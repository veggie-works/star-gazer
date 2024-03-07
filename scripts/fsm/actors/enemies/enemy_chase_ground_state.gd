## When the enemy is chasing a target
class_name EnemyChaseGroundState extends EnemyState

## The speed at which the enemy chases a target
@export var chase_speed: float = 150

func enter() -> void:
	if animator.has_animation("chase"):
		animator.play("chase")
		
func update(_delta: float) -> void:
	var direction = sign(fsm.current_target.global_position.x - body.global_position.x)
	body.velocity.x = direction * chase_speed

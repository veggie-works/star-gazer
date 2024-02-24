## When the enemy is chasing a target
class_name EnemyChaseGroundState extends EnemyState

func enter() -> void:
	if animator.has_animation("chase"):
		animator.play("chase")
		
func update(delta: float) -> void:
	var direction = sign(fsm.current_target.global_position.x - body.global_position.x)
	body.run(direction)

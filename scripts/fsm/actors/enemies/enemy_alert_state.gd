## When the enemy is alerted of the player
class_name EnemyAlertState extends EnemyState

## The state for when the enemy is chasing a target
@export var chase_state: EnemyState

func enter() -> void:
	body.velocity.x = 0
	if animator.has_animation("alert"):
		animator.play("alert")
		await animator.animation_finished
	fsm.set_state(chase_state)

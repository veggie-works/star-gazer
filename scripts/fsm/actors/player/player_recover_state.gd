## Player recovery state
class_name PlayerRecoverState extends PlayerState

## The duration of invincibility granted to the player after a perfect recovery
@export var perfect_recovery_invincibility_time: float = 1

## The health manager on the player
@onready var health_manager: HealthManager = %health_manager

func enter() -> void:
	if AudioManager.perfect_recovery:
		perfect_recovery()
	body.velocity = Vector2.ZERO
	#animator.play("recover")
	#await animator.animation_finished
	fsm.transition_to(PlayerFallState)

## Perform a perfect recovery
func perfect_recovery() -> void:
	print("PERFECT RECOVERY")
	health_manager.add_health(health_manager.last_damage_taken * 0.25)
	health_manager.invincible = true
	await get_tree().create_timer(perfect_recovery_invincibility_time).timeout
	print("CANCEL INVINCIBILITY")
	health_manager.invincible = false

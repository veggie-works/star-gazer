## Player recovery state
class_name PlayerRecoverState extends PlayerState

## The duration of invincibility granted to the player after a perfect recovery
@export var perfect_recovery_invincibility_time: float = 1

## The health manager on the player
@onready var health_manager: HealthManager = %health_manager
## Controls pulsing while invincibile after a perfect recovery
@onready var pulser: Pulser = %pulser

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
	# Disable invincibility so it doesn't re-enable hurt box after damage invincibility timer expires
	health_manager.invincible = false
	# Disable hitbox directly to avoid starting damage invincibility timer
	health_manager.hurt_box.disabled = true
	health_manager.invincible_time = INF
	pulser.start_pulse(Color.WHITE)
	await get_tree().create_timer(perfect_recovery_invincibility_time).timeout
	health_manager.set_invincible(false)

## Player damaged state
class_name PlayerHurtState extends PlayerState

## The duration of invincibility gained when taking damage
@export var invincibility_time: float = 1

## The player's health manager
@onready var health_manager: HealthManager = %health_manager

func _ready() -> void:
	body.landed.connect(on_land)

func enter() -> void:
	# animator.play("hurt")
	health_manager.invincible = true
	await get_tree().create_timer(invincibility_time).timeout
	health_manager.invincible = false

func update(delta: float) -> void:
	if Input.is_action_just_pressed("block"):
		fsm.transition_to(PlayerRecoverState)

## Callback for when the player lands during the hurt state
func on_land() -> void:
	fsm.transition_to(PlayerIdleState)

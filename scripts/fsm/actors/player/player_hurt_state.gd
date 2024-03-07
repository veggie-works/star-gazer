## Player damaged state
class_name PlayerHurtState extends PlayerState

func _ready() -> void:
	body.landed.connect(on_land)

func enter() -> void:
	animator.play("hurt")

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("dodge"):
		fsm.transition_to(PlayerRecoverState)

## Callback for when the player lands during the hurt state
func on_land() -> void:
	fsm.transition_to(PlayerIdleState)

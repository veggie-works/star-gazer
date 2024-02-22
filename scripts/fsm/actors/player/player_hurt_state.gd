## Player damaged state
class_name PlayerHurtState extends PlayerState

## The health manager's hit box
var hurt_box: CollisionShape2D

func _ready() -> void:
	# My body is ready
	await body.ready
	hurt_box = body.get_node("behaviors/health_manager/hurt_box")
	body.landed.connect(on_land)

func enter() -> void:
	# animator.play("hurt")
	body.disable_input = true
	if hurt_box != null:
		hurt_box.set_deferred("disabled", true)

func update(delta: float) -> void:
	if Input.is_action_just_pressed("block"):
		fsm.transition_to(PlayerRecoverState)

func exit() -> void:
	body.disable_input = false
	if hurt_box != null:
		hurt_box.disabled = false

## Callback for when the player lands during the hurt state
func on_land() -> void:
	fsm.transition_to(PlayerIdleState)

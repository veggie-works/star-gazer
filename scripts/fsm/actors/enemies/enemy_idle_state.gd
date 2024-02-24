## When the enemy is idling
class_name EnemyIdleState extends EnemyState

## The minimum duration that the enemy can be idle for
@export var idle_time_min: float = 1
## The maximum duration that the enemy can be idle for
@export var idle_time_max: float = 2
## The next state that the enemy should transition after being idle
@export var idle_timeout_next_state: GDScript

## Controls how long the enemy should be idle for
@onready var idle_timer: Timer = %idle_timer

func enter() -> void:
	if animator.has_animation("idle"):
		animator.play("idle")
	body.velocity.x = 0
	idle_timer.start(randf_range(idle_time_min, idle_time_max))

func exit() -> void:
	idle_timer.stop()

func update(delta: float) -> void:
	if fsm.current_target != null:
		fsm.transition_to(EnemyAlertState)

func _on_idle_timer_timeout() -> void:
	fsm.transition_to(idle_timeout_next_state)

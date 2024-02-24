## When the enemy is wandering the level
class_name EnemyWanderState extends EnemyState

## The animation to play while wandering
@export var wander_animation: String = "wander"
## The speed at which the enemy wanders
@export var wander_speed: float = 200
## The time for which the enemy wanders for
@export var wander_time: float = 3
## Controls how long the enemy should wander for
@onready var wander_timer: Timer = %wander_timer

func _ready() -> void:
	if wander_timer != null:
		wander_timer.timeout.connect(on_wander_timer_timeout)

func enter() -> void:
	if animator.has_animation(wander_animation):
		animator.play(wander_animation)
	body.move(Vector2([-1, 1][randi_range(0, 1)] * wander_speed, 0))
	if wander_timer != null:
		wander_timer.start(wander_time)

func exit() -> void:
	wander_timer.stop()

func update(delta: float) -> void:
	if fsm.current_target != null:
		fsm.transition_to(EnemyAlertState)

## Callback for when the wander timer expires
func on_wander_timer_timeout() -> void:
	fsm.transition_to(EnemyIdleState)

## When the enemy is wandering the level
class_name EnemyWanderState extends EnemyState

## The animation to play while wandering
@export var wander_animation: String = "wander"
## The speed at which the enemy wanders
@export var wander_speed: float = 75
## The number of beats that the enemy wanders for
@export var wander_beats: int = 3

## The current number of beats that have occurred
var beat_count: int

func enter() -> void:
	beat_count = 0
	if not AudioManager.downbeat.is_connected(on_downbeat):
		AudioManager.downbeat.connect(on_downbeat)
	if animator.has_animation(wander_animation):
		animator.play(wander_animation)
	body.move(Vector2([-1, 1][randi_range(0, 1)] * wander_speed, 0))

func exit() -> void:
	if AudioManager.downbeat.is_connected(on_downbeat):
		AudioManager.downbeat.disconnect(on_downbeat)

func on_downbeat() -> void:
	beat_count += 1
	if beat_count >= wander_beats:
		fsm.transition_to(EnemyIdleState)

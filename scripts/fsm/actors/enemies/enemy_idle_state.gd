## When the enemy is idling
class_name EnemyIdleState extends EnemyState

## The minimum number of beats that the enemy can be idle for
@export var idle_beats_min: int = 2
## The maximum number of beats that the enemy can be idle for
@export var idle_beats_max: int = 3
## The next state that the enemy should transition after being idle
@export var next_state: GDScript

## The current number of beats counted
var beat_count: int
## The number of beats until the transition to the next state
var idle_beats: int

func enter() -> void:
	if not AudioManager.downbeat.is_connected(on_downbeat):
		AudioManager.downbeat.connect(on_downbeat)
	if animator.has_animation("idle"):
		animator.play("idle")
	body.velocity.x = 0
	beat_count = 0
	idle_beats = randi_range(idle_beats_min, idle_beats_max)

func exit() -> void:
	if AudioManager.downbeat.is_connected(on_downbeat):
		AudioManager.downbeat.disconnect(on_downbeat)

## Callback for when a downbeat occurs
func on_downbeat() -> void:
	beat_count += 1
	if beat_count >= idle_beats:
		fsm.transition_to(EnemyWanderState)

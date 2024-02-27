## Player running state
class_name PlayerRunState extends PlayerState

## The random table of clips to choose a footstep sound from
@export var footstep_clip_table: RandomAudioClipTable
## Interval of time between footsteps
@export var footstep_interval: float = 0.4
## The speed that the player runs at
@export var run_speed: float = 600

## Timer that counts down between footsteps
@onready var footstep_timer: Timer = $footstep_timer

func _ready() -> void:
	if footstep_timer != null:
		footstep_timer.timeout.connect(on_footstep_timer_timeout)

func enter() -> void:
	animator.play("run")
	if footstep_timer != null:
		footstep_timer.start(footstep_interval)

func exit() -> void:
	if footstep_timer != null:
		footstep_timer.stop()

func update(delta: float) -> void:
	if body.velocity.y > 0:
		fsm.transition_to(PlayerFallState)
		
	if body.disable_input:
		return
		
	body.velocity.x = 0	
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if abs(direction) <= 0:
		fsm.transition_to(PlayerIdleState)
		return
	body.velocity.x += direction * run_speed
	if body.is_grounded() and Input.is_action_just_pressed("jump"):
		fsm.transition_to(PlayerJumpState)

## Callback for when the footstep timer expires
func on_footstep_timer_timeout() -> void:
	footstep_clip_table.play_random(0.85, 1.15)

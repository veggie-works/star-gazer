## An enemy's state machine
class_name EnemyFSM extends StateMachine

## The enemy's line of sight
@onready var line_of_sight: LineOfSight = %line_of_sight

## The current player being targeted
var current_target: Player

func _ready() -> void:
	super._ready()
	if line_of_sight != null:
		line_of_sight.seen.connect(on_seen)

## Callback for when the player has seen a player
func on_seen(target: Player) -> void:
	current_target = target

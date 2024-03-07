## Player-specific state
class_name PlayerState extends State

## The player's root body node
@onready var body: Player = get_owner()
## The player's animation controller
@onready var animator: AnimationPlayer = body.get_node("animator")

## The function that the player FSM will pass inputs into
func input(_event: InputEvent) -> void:
	pass

## Represents an object that may be interacted with by the player
class_name InteractArea extends Area2D

## Emitted when a player interacts
signal interact

## The player that entered the area
var player: Player

## Whether a player is in range of the interact area
var in_range: bool:
	get:
		return player != null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and in_range:
		interact_with(player)

## Interact with a player
func interact_with(body: Player) -> void:
	interact.emit()
	# Force transition to idle state
	body.get_node("fsm").transition_to(PlayerIdleState)
	body.in_cutscene = true

func _on_body_entered(body: Player) -> void:
	player = body

func _on_body_exited(_body: Player) -> void:
	player = null

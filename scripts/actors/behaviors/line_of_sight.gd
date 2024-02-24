## Detects whether a player is in sight
class_name LineOfSight extends Node2D

## The range at which this line of sight can see its target
@export var sight_length: float = 800
## The target that is being tracked
@export var current_targets: Array
## The node group to target
@export var target_group: String

@onready var raycast: RayCast2D = $raycast

signal seen(target: Node2D)

func _process(delta: float) -> void:
	if len(target_group) > 0:
		current_targets = get_tree().get_nodes_in_group(target_group)
	var current_target: Node = Globals.get_closest(self, current_targets)
	if current_target != null:
		raycast.target_position = (current_target.global_position - global_position).normalized() * sight_length
		## Keep scale positive
		raycast.global_transform.x.x = 1
		if raycast.is_colliding():
			var collider: Object = raycast.get_collider()
			if (len(target_group) > 0 and collider.is_in_group(target_group)) or current_targets.has(collider):
				seen.emit(collider)

## Detects whether a player is in sight
class_name LineOfSight extends Node2D

## The range at which this line of sight can see its target
@export var sight_length: float = 800
## All targets that are being tracked
@export var all_targets: Array
## The node group to target
@export var target_group: String

@onready var raycast: RayCast2D = $raycast

signal seen(target: Node2D)

## The closest target that is being tracked
var closest_target: Node

func _process(_delta: float) -> void:
	if len(target_group) > 0:
		all_targets = get_tree().get_nodes_in_group(target_group)
	var closest: Node2D = Globals.get_closest(self, all_targets)
	if closest:
		raycast.target_position = (closest.global_position - global_position).normalized() * sight_length
		## Keep scale positive
		raycast.global_transform.x.x = 1
		if raycast.is_colliding():
			var collider: Object = raycast.get_collider()
			if closest_target != collider and ((len(target_group) > 0 and \
				collider.is_in_group(target_group)) or all_targets.has(collider)):
				closest_target = collider
				seen.emit(collider)

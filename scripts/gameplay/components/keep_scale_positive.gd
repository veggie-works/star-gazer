## Keeps the root node's scale positive
extends Node2D

func _process(delta: float) -> void:
	force_scale_positive.call_deferred(owner)

## Force the owner's global scale to be positive
func force_scale_positive(root: Node) -> float:
	var root_scale: float = -1
	if root is Node2D:
		root_scale = root.global_scale.x
		root.global_transform.x.x *= root_scale
	elif root is Control:
		root_scale = force_scale_positive(root.owner)
		root.scale *= root_scale
		
	return root_scale

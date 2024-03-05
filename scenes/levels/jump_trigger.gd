extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.in_cutscene = true
		var target_position: Vector2 = get_node("../jump_target").global_position
		body.jump_to(target_position)
		await body.landed
		body.in_cutscene = false

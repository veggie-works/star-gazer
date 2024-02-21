extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.in_cutscene = true
		var target_position: Vector2 = get_node("../save_point").global_position
		body.jump_to(target_position, target_position.y - 25, 1)
		await body.landed
		body.in_cutscene = false

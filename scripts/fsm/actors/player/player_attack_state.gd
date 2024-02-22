## Player attacking state
class_name PlayerAttackState extends PlayerState

func _ready() -> void:
	if body.is_grounded():
		pass
		#animator.play("attack")
		#await animator.animation_finished
	else:
		pass
		#animator.play("air_attack")
		#await animator.animation_finished

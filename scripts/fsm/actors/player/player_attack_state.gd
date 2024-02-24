## Player attacking state
class_name PlayerAttackState extends PlayerState

@onready var weapon_manager: WeaponManager = %weapon_manager

func enter() -> void:
	if body.is_grounded():
		weapon_manager.attack()
		#animator.play("attack")
		#await animator.animation_finished
	else:
		weapon_manager.attack()
		#animator.play("air_attack")
		#await animator.animation_finished

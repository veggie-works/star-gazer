## Base class for weapon attacks
class_name Attack extends CollisionObject2D

## The weapon associated with this attack
var weapon: Weapon

## The force with which the attack is made, affects the amount that the hit actor recoils
@export_range(100, 1000) var attack_force: float = 250

## The angle of the attack in degrees, affects the direction that the hit actor recoils in
@export_range(0, 360) var attack_angle: float = 0

## Perform an attack
func attack() -> void:
	pass

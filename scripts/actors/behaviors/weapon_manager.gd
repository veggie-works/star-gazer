## Management of the root actor's weapons
class_name WeaponManager extends Node2D

## The currently wielded weapon
@export var weapon: Weapon

func attack() -> void:
	var attack_object: CollisionObject2D = weapon.attack_prefab.instantiate()
	if attack_object is DamageArea:
		attack_object.attack()

## Management of the root actor's weapons
class_name WeaponManager extends Node2D

## The currently wielded weapon
@export var weapon: Weapon

## The actor that owns this weapon manager
@onready var actor: Actor = get_owner()

## Whether the player is in an attack
var in_attack: bool

## Attack with the wielded weapon
func attack() -> void:
	if in_attack:
		return
	var attack_object: Attack = weapon.attack_prefab.instantiate()
	attack_object.weapon = weapon
	if global_transform.x.x < 0:
		var x: float = cos(deg_to_rad(attack_object.attack_angle))
		var y: float = sin(deg_to_rad(attack_object.attack_angle))
		x *= -1
		attack_object.attack_angle = rad_to_deg(atan2(y, x))
	add_child(attack_object)
	if attack_object is DamageArea:
		in_attack = true
		attack_object.attack()
		await attack_object.animator.animation_finished
		attack_object.queue_free()
		in_attack = false

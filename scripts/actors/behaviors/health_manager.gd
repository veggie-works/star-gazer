## Contains data about an actor's health
class_name HealthManager extends Area2D

## The actor's maximum amount of health
@export var max_health: float = 25
## Whether the actor is immune to damage
@export var invincible: bool

## The collision shape that triggers a damage event
@onready var hurt_box: CollisionShape2D = $hurt_box

## Emitted when the actor heals
signal healed(heal_amount: float)
## Emitted when the actor takes damage
signal took_damage(attack: Attack)

## The actor's current health value
var current_health: float = max_health

## Whether the actor is dead
var is_dead: bool:
	get:
		return current_health <= 0

var recoil_manager: RecoilManager:
	get:
		return get_node("../recoil_manager")

## Add to the player's health value
func add_health(heal_amount: float) -> void:
	current_health = min(max_health, current_health + heal_amount)
	healed.emit(heal_amount)
	
## Fully heal the actor
func full_heal() -> void:
	add_health(max_health - current_health)

## Take damage to the actor
func take_damage(attack: Attack) -> void:
	if invincible:
		return
	var damage_amount: float = attack.weapon.damage
	current_health = max(0, current_health - damage_amount)
	took_damage.emit(attack)
	if is_dead:
		die()
		return
	if recoil_manager != null:
		recoil_manager.recoil(attack.attack_angle, attack.attack_force)

## Actor death
func die() -> void:
	pass

func _on_area_entered(area: DamageArea) -> void:
	take_damage(area)

func _on_body_entered(body: Projectile) -> void:
	take_damage(body)
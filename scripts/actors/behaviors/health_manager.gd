## Contains data about an actor's health
class_name HealthManager extends Area2D

## The actor's maximum amount of health
@export var max_health: float = 25
## Whether to shake the camera on hit
@export var shake_camera: bool = false
## The duration that the actor is invincible for when hit
@export var invincibility_time: float = 0.2

## The actor's current health value
@onready var current_health: float = max_health
## The collision shape that triggers a damage event
@onready var hurt_box: CollisionShape2D = $hurt_box
## Controls flashiing after taking damage
@onready var flasher: Flasher = get_node_or_null("../flasher")
## Controls pulsing while invincible after taking damage
@onready var pulser: Pulser = get_node_or_null("../pulser")
## Used to recoil the actor when taking damage
@onready var recoil_manager: RecoilManager = get_node_or_null("../recoil_manager")
## Used to shake the actor on damage
@onready var shaker: Shaker = get_node_or_null("../shaker")

## Emitted when the actor heals
signal healed(heal_amount: float)
## Emitted when the actor takes damage
signal took_damage(attack: Attack)

## The amount of damage most recently taken
var last_damage_taken: float

## The current duration that the actor has been invincible for
var invincible_time: float = INF

## The ratio of current health to max health
var health_ratio: float:
	get:
		return current_health / max_health

## Whether the actor is immune to damage
var invincible: bool

## Whether the actor is dead
var is_dead: bool:
	get:
		return current_health <= 0

func _process(delta: float) -> void:
	if invincible:
		invincible_time += delta
		if invincible_time >= invincibility_time:
			set_invincible(false)

## Add to the player's health value
func add_health(heal_amount: float) -> void:
	current_health = min(max_health, current_health + heal_amount)
	healed.emit(heal_amount)
	
## Fully heal the actor
func full_heal() -> void:
	add_health(max_health - current_health)

## Take damage to the actor
func take_damage(attack: Attack) -> void:
	owner.face(attack)
	set_invincible()
	var damage_amount: float = attack.weapon.damage
	current_health = max(0, current_health - damage_amount)
	last_damage_taken = damage_amount
	took_damage.emit(attack)
	if shake_camera:
		GameCamera.shake(25, 0.25)
	if is_dead:
		die()
		return
	if recoil_manager:
		recoil_manager.recoil(attack.attack_angle, attack.attack_force)
	if shaker:
		shaker.shake(15, 0.25)

## Actor death
func die() -> void:
	owner.queue_free()

## Set actor as invincible (setter doesn't work)
func set_invincible(value: bool = true) -> void:
	invincible = value
	hurt_box.set_deferred("disabled", value)
	if value:
		invincible_time = 0.0
		if pulser:
			pulser.start_pulse()
		elif flasher:
			flasher.flash()
	else:
		invincible_time = INF
		if pulser and pulser.is_pulsing:
			pulser.stop_pulse()

func _on_area_entered(area: DamageArea) -> void:
	if invincible:
		return
	take_damage(area)

func _on_body_entered(body: Projectile) -> void:
	if invincible:
		return
	take_damage(body)

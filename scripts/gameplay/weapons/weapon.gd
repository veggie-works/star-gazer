## Represents a weapon wielded by an actor
class_name Weapon extends Resource

## The amount of damage that this weapon deals
@export var damage: float = 5

## The prefab of the attack object that spawns when attacking
@export var attack_prefab: PackedScene

## The collision mask of the spawned attack
@export_flags_2d_physics var attack_trigger_mask

## Whether to parent the spawned attack to the object that spawned it
@export var parent_attack_to_spawner: bool

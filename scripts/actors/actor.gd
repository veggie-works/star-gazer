## Base class for all actors, e.g players, enemies, NPCs
class_name Actor extends CharacterBody2D

func _process(_delta: float) -> void:
	move_and_slide()

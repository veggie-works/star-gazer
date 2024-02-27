## A transition from or into another scene
class_name Door extends Node2D

## The player prefab to spawn at the door when entering from a different scene
@export var player_prefab: PackedScene

## The scene that this door transitions to when entered
@export_file("*.tscn") var target_scene: String

## The name of the door that this door leads to in the next scene
@export var target_name: String

## The direction the player should enter from this door
@export_enum("left", "right", "top", "down") var enter_direction = "left"

## The door's collision shape
@onready var collision: CollisionShape2D = $collision

## The root of the level scene that contains this door
@onready var level_root: Node = get_owner()

## Walk the player from this door into the scene
func enter_from() -> void:
	var player: Player = player_prefab.instantiate()
	player.in_cutscene = true
	collision.disabled = true
	level_root.add_child(player)
	player.global_position = global_position
	GameCamera.targets.clear()
	GameCamera.targets.append(player)
	if enter_direction == "left" or enter_direction == "right":
		var target_sign: float
		match enter_direction:
			"left":
				target_sign = -1
			"right":
				target_sign = 1
		var target_x = global_position.x + target_sign * (collision.shape.get_rect().size.x / 2 + player.get_node("collision").shape.get_rect().size.x / 2 + 4)
		player.move_to(target_x)
		await player.arrived
	else:
		await player.landed
	collision.disabled = false
	player.in_cutscene = false

func _on_area_entered(area: Area2D) -> void:
	var body: Node = area.get_owner()
	if body is Player:
		body.in_cutscene = true
		if enter_direction == "left" or enter_direction == "right":
			var target_sign: float = sign(global_position.x - body.global_position.x)
			var target_x: float = global_position.x + target_sign * (collision.shape.get_rect().size.x / 2 + body.get_node("collision").shape.get_rect().size.x / 2 + 64)
			body.move_to(target_x)
		SceneManager.change_scene(target_scene, target_name)

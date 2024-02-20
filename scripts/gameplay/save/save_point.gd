## An object where the player may save their game
class_name SavePoint extends Node2D

## The player prefab to instantiate on load
@export var player_prefab: PackedScene

## The root of the level scene that this save point is located in
@onready var level_root: BaseLevel = get_owner()

## Load this save point as the last save
func load_save() -> void:
	var player: Player = player_prefab.instantiate()
	level_root.add_child(player)
	player.global_position = SaveManager.save_data.save_position
	
## Save the game
func save() -> void:
	SaveManager.save_data.save_scene = SceneManager.current_scene
	SaveManager.save_data.save_position = global_position

func _on_save_area_body_entered(body: PhysicsBody2D):
	if body is Player:
		save()

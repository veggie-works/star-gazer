## An object where the player may save their game
class_name SavePoint extends Node2D

## The name of this save point that will be displayed in the fast travel menu
@export var save_point_name: String

## The player prefab to instantiate on load
@export var player_prefab: PackedScene

## The root of the level scene that this save point is located in
@onready var level_root: BaseLevel = get_owner()

## The data associated with this save point
var data: SavePointData

func _ready() -> void:
	data = SavePointData.new()
	data.save_point_name = save_point_name
	data.save_scene = get_tree().current_scene.scene_file_path
	data.save_position = global_position

## Load this save point as the last save
func load_save(save_point_data: SavePointData) -> void:
	var player: Player = player_prefab.instantiate()
	level_root.add_child(player)
	player.global_position = save_point_data.save_position
	GameCamera.set_target(player)
	
## Save the game
func save() -> void:
	SaveManager.save_data.last_save_point = data
	if not SaveManager.save_data.visited_save_points.any(func(save_point_data): return save_point_data.equals(data)):
		SaveManager.save_data.visited_save_points.append(data)
	for player: Player in get_tree().get_nodes_in_group("players"):
		player.health_manager.full_heal()

func _on_interact_area_interact() -> void:
	save()
	UIManager.open_ui(FastTravelUI)

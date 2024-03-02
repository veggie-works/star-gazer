## Displays the world map
class_name MapUI extends BaseUI

## The game map data to use
@export var map_data: GameMap
## Prefab to instantiate for every level
@export var level_prefab: PackedScene

## Parent panel of all UI elements
@onready var panel: Panel = $panel
## The sprite depicting where the player is located on the map
@onready var player_location: Sprite2D = panel.get_node("player_location_sprite")
## Container for all level sprites
@onready var levels: Node2D = panel.get_node("levels")

## The level sprite of the current scene
var current_level: MapLevel:
	get:
		if get_tree().current_scene == null:
			return null
		var filtered_levels: Array[Node] = levels.get_children().filter(func(level):
			return level is MapLevel and level.data.level_name == get_tree().current_scene.name)
		if len(filtered_levels) > 0:
			return filtered_levels[0]
		return null

func _ready() -> void:
	init_map()
	
func _process(delta: float) -> void:
	player_location.position = get_player_position_on_map()

## Initialize the game map UI
func init_map() -> void:
	for level_data: MapLevelData in map_data.levels:
		var level: MapLevel = level_prefab.instantiate()
		level.data = level_data
		var level_texture: Texture2D = load(level_data.image_file_path)
		level.texture = level_texture
		level.position = level_texture.get_size() / 2 + level_data.rect_in_map.position
		levels.add_child(level)

## Get the current player's position
func get_player_position_on_map() -> Vector2:
	if current_level == null:
		return Vector2.ZERO
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	if len(players) > 0:
		var player: Player = players[0]
		var tile_map: TileMap = get_tree().current_scene.get_node("tile_map")
		var tile_size: float = tile_map.tile_set.tile_size.x
		var tile_offset: Vector2 = tile_map.get_used_rect().position * tile_size
		var offset: Vector2 = current_level.data.rect_in_map.position - tile_offset
		var player_pos: Vector2 = player.global_position + offset
		return player_pos
	return Vector2.ZERO

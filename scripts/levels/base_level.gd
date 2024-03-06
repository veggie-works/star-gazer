## Base class for all levels in the game
class_name BaseLevel extends Node

## The music track played in this scene
@export var music_track: MusicTrack

## The level's tile map
@onready var tile_map: TileMap = get_node_or_null("tile_map")

func _ready() -> void:
	open_uis()
	play_music()
	setup_camera()

func _exit_tree() -> void:
	UIManager.close_ui(HUD)
	if OS.is_debug_build():
		UIManager.close_ui(DebugPanel)

func _input(event: InputEvent) -> void:
	if self is MainMenu:
		return
	if event.is_action_pressed("inventory"):
		var map_ui: MapUI = UIManager.get_ui(MapUI)
		if map_ui == null or not map_ui.visible:
			UIManager.open_ui(MapUI)
		else:
			UIManager.close_ui(MapUI)

## Load the save point in this scene
func load_save_point(save_point_data: SavePointData) -> void:
	var save_points: Array[Node] = get_tree().get_nodes_in_group("save_points")
	for save_point in save_points:
		if save_point is SavePoint and save_point.equals(save_point_data.save_position):
			save_point.load_save(save_point_data)
			return

## Open gameplay UIs
func open_uis() -> void:
	UIManager.open_ui(HUD)
	if OS.is_debug_build():
		UIManager.open_ui(DebugPanel)

## Play the level's music track if it exists
func play_music() -> void:
	if music_track:
		AudioManager.play_music(music_track)

## Set up the game camera for this specific level
func setup_camera() -> void:
	GameCamera.enabled = true
	if tile_map == null:
		return
	# Set camera limits
	var tile_rect: Rect2i = tile_map.get_used_rect()
	var tile_size: int = tile_map.tile_set.tile_size.x
	var scaled_rect := Rect2i(tile_rect.position * tile_size, tile_rect.size * tile_size)
	GameCamera.limit_left = scaled_rect.position.x
	GameCamera.limit_right = scaled_rect.end.x
	GameCamera.limit_top = scaled_rect.position.y
	GameCamera.limit_bottom = scaled_rect.end.y

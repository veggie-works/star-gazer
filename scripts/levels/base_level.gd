## Base class for all levels in the game
class_name BaseLevel extends Node

## The music track played in this scene
@export var music_track: MusicTrack

func _ready() -> void:
	if music_track:
		AudioManager.play_music(music_track)
	UIManager.open_ui(HUD)
	GameCamera.enabled = true

func _exit_tree() -> void:
	UIManager.close_ui(HUD)

func _input(event: InputEvent) -> void:
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

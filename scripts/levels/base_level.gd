## Base class for all levels in the game
class_name BaseLevel extends Node

## The music track played in this scene
@export var music_track: MusicTrack

func _ready() -> void:
	AudioManager.play_music(music_track)
	UIManager.open_ui(HUD)
	GameCamera.targets.clear()
	for player in get_tree().get_nodes_in_group("players"):
		if player is Player:
			GameCamera.targets.append(player)

## Load the save point in this scene
func load_save_point() -> void:
	var save_points: Array[Node] = get_tree().get_nodes_in_group("save_points")
	for save_point in save_points:
		if save_point is SavePoint and (save_point.global_position - SaveManager.save_data.save_position).length() <= 0.1:
			save_point.load_save()
			return

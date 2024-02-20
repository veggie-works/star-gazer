## Base class for all levels in the game
class_name BaseLevel extends Node

func _ready() -> void:
	var save_points: Array[Node] = get_tree().get_nodes_in_group("save_points")
	for save_point in save_points:
		if save_point is SavePoint:
			if (save_point.global_position - SaveManager.save_data.save_position).length() <= 0.1:
				save_point.load_save()
				return

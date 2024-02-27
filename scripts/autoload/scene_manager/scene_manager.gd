## Manages loading and unloading of scenes
extends Node

## A list of all level scenes
@export var level_scenes: Array[PackedScene] = []

## Emitted whenever a scene changes	
signal scene_changed(old_scene: String, new_scene: String)

## Change to a new scene
func change_scene(scene_path: String, door_name: String = "") -> void:
	var fader: BaseUI = UIManager.open_ui(Fader)
	var old_scene_path = get_tree().current_scene.scene_file_path
	await fader.faded_in
	if get_tree().change_scene_to_file(scene_path) != OK:
		printerr("Failed to load scene at ", scene_path)
		return
	await get_tree().process_frame
	scene_changed.emit(old_scene_path, scene_path)
	if len(door_name) > 0:
		var doors = get_tree().get_nodes_in_group("doors").filter(func(door): return door.name == door_name)
		if len(doors) > 0 and doors[0] is Door:
			doors[0].enter_from.call_deferred()
	else:
		var save_points = get_tree().get_nodes_in_group("save_points").filter(func(save_point):
			print(save_point.name, "\t", (save_point.global_position - SaveManager.save_data.save_position).length())
			return (save_point.global_position - SaveManager.save_data.save_position).length() <= 1
		)
		if len(save_points) > 0 and save_points[0] is SavePoint:
			save_points[0].load_save()
	fader.close()
	await fader.faded_out

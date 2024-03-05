## Manages loading and unloading of scenes
extends Node

## Emitted whenever a scene changes	
signal scene_changed(old_scene: String, new_scene: String)

## Generic scene change function
func change_scene(scene_path: String) -> void:
	var fader: BaseUI = UIManager.open_ui(Fader)
	var old_scene_path = get_tree().current_scene.scene_file_path
	await fader.faded_in
	if get_tree().change_scene_to_file(scene_path) != OK:
		printerr("Failed to load scene at ", scene_path)
		return
	await get_tree().process_frame
	scene_changed.emit(old_scene_path, scene_path)
	fader.close()
	await fader.faded_out

## Change to a new scene from one door to another
func change_scene_between_doors(scene_path: String, door_name: String, enter_scale: float) -> void:
	var fader: BaseUI = UIManager.open_ui(Fader)
	var old_scene_path = get_tree().current_scene.scene_file_path
	await fader.faded_in
	if get_tree().change_scene_to_file(scene_path) != OK:
		printerr("Failed to load scene at ", scene_path)
		return
	await get_tree().process_frame
	scene_changed.emit(old_scene_path, scene_path)
	var doors = get_tree().get_nodes_in_group("doors").filter(func(door): return door.name == door_name)
	if len(doors) > 0 and doors[0] is Door:
		doors[0].enter_from(enter_scale)
	fader.close()
	await fader.faded_out

## Change to a new scene, loading from a save point
func change_scene_load_save_point(save_point_data: SavePointData) -> void:
	var fader: BaseUI = UIManager.open_ui(Fader)
	var old_scene_path = get_tree().current_scene.scene_file_path
	await fader.faded_in
	var target_scene: String = save_point_data.save_scene
	if get_tree().change_scene_to_file(target_scene) != OK:
		printerr("Failed to load scene at ", target_scene)
		return
	await get_tree().process_frame
	scene_changed.emit(old_scene_path, target_scene)
	var save_points = get_tree().get_nodes_in_group("save_points").filter(func(save_point): return save_point.data.equals(save_point_data))
	if len(save_points) > 0 and save_points[0] is SavePoint:
		save_points[0].load_save(save_point_data)
	fader.close()
	await fader.faded_out


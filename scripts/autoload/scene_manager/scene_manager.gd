## Manages loading and unloading of scenes
extends Node

## A list of all level scenes
@export var level_scenes: Array[PackedScene] = []

## The screen viewport containing the current level
@onready var screen: Viewport = get_node("/root/main/screen_container/screen")

## Emitted whenever a scene changes	
signal scene_changed(old_scene: String, new_scene: String)

## The name of the currently loaded scene
var current_scene: String

## Change to a new scene
func change_scene(scene_path: String, door_name: String = "") -> void:
	var fader: BaseUI = UIManager.open_ui(Fader)
	var old_scene = current_scene
	current_scene = scene_path
	var loaded_scene: PackedScene = load(scene_path)
	await fader.faded_in
	for child in screen.get_children():
		screen.remove_child(child)
	var instantiated_scene: Node = loaded_scene.instantiate()
	screen.add_child(instantiated_scene)
	scene_changed.emit(old_scene, scene_path)
	if len(door_name) > 0:
		var doors = get_tree().get_nodes_in_group("doors").filter(func(door): return door.name == door_name)
		if len(doors) > 0 and doors[0] is Door:
			doors[0].enter_from.call_deferred()
	else:
		var save_points = get_tree().get_nodes_in_group("save_points").filter(func(point): 
			return (point.global_position - SaveManager.save_data.save_position).length() <= 0.1
		)
		print("Save points: ", JSON.stringify(save_points))
		if len(save_points) > 0 and save_points[0] is SavePoint:
			save_points[0].load_save()
	fader.close()
	await fader.faded_out

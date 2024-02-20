## Manages loading and unloading of scenes
extends Node

## A list of all level scenes
@export var level_scenes: Array[PackedScene] = []

## The screen viewport containing the current level
@onready var screen: Viewport = get_node("/root/main/screen_container/screen")

## Emitted whenever a scene changes
signal scene_changed(old_scene: BaseLevel, new_scene: BaseLevel)

## Change to a new scene
func change_scene(scene_type: GDScript) -> void:
	var fader: BaseUI = UIManager.open_ui(Fader)
	var old_scene = get_tree().current_scene
	await fader.faded_in
	for child in screen.get_children():
		screen.remove_child(child)
	var scenes: Array[PackedScene] = level_scenes.filter(func(scene):
		var scene_state = scene.get_state()
		for i in range(0, scene_state.get_node_property_count(0)):
			var prop_value = scene_state.get_node_property_value(0, i)
			if prop_value is GDScript and prop_value == scene_type:
				return prop_value
	)
	if len(scenes) > 0:
		var instantiated_scene: BaseLevel = scenes[0].instantiate()
		screen.add_child(instantiated_scene)
		scene_changed.emit(old_scene, instantiated_scene)
	UIManager.close_ui(Fader)
	await fader.faded_out

## Singleton containing miscellaneous constant values and helper functions
extends Node

## The default gravity value, in pixels per second squared
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

## Recursively load scenes and fetch the one whose script that matches the script parameter
func find_scene_by_type(type: GDScript, search_dir: String = "res://") -> PackedScene:
	var dir := DirAccess.open(search_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var file_path = "%s/%s" % [search_dir, file_name]
			print("File path: ", file_path)
			if dir.current_is_dir():
				return find_scene_by_type(type, file_path)
			else:
				var packed_scene: PackedScene = load(file_path)
				var scene_state: SceneState = packed_scene.get_state()
				for i in range(0, scene_state.get_node_property_count(0)):
					var prop_value = scene_state.get_node_property_value(0, i)
					print("Prop val: ", JSON.stringify(prop_value))
					if prop_value is GDScript and prop_value == type:
						return packed_scene
	return null

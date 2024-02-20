## Manages the saving and loading of game data
extends Node

## Name of the file containing the save data, suffixed with a profile ID
const SAVE_FILE_NAME: String = "data"

## The path to the file containing global game settings
const SETTINGS_PATH: String = "user://settings.tres"

## The current settings instance
var settings := Settings.new()

## The currently loaded save game data
var save_data: Dictionary

## The ID of the selected profile
var selected_profile_id: int = 0

## The location of the selected profile's save file
var save_path: String:
	get:
		return "user://%s%d.json" % [SAVE_FILE_NAME, selected_profile_id]

func _init() -> void:
	settings = load_settings()

## Load game data and settings from disk
func load_game(profile_id: int = 0) -> void:
	selected_profile_id = profile_id
	save_data = load_game_data()

## Load game data from disk
func load_game_data() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		print("No save data found, creating new save")
		return {}
		
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	var save_json = JSON.new()
	if save_json.parse(save_file.get_as_text()) != OK:
		printerr("Error parsing save data")
		return {}

	return save_json.data
	
## Load settings from disk
func load_settings() -> Settings:
	if not ResourceLoader.exists(SETTINGS_PATH):
		return Settings.new()
	return ResourceLoader.load(SETTINGS_PATH)

## Save game data and settings to disk
func save_game() -> void:
	save_game_data()
	save_settings()

## Save game data to disk
func save_game_data() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("save")
	for save_node in save_nodes:
		if not save_node.has_method("save"):
			continue
		var node_data = save_node.call("save")
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)
	save_file.close()
	
## Save settings to disk
func save_settings() -> void:
	ResourceSaver.save(settings, SETTINGS_PATH)

func _on_tree_exiting() -> void:
	save_game()

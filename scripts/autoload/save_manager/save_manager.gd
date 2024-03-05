## Manages the saving and loading of game data
extends Node

## Name of the file containing the save data, suffixed with a profile ID
const SAVE_FILE_NAME: String = "data"

## The path to the file containing global game settings
const SETTINGS_PATH: String = "user://settings.tres"

## The default save configuration if a new game is started
@export var default_save: SaveData

## The current settings instance
var settings := Settings.new()

## The currently loaded save game data
var save_data: SaveData

## The ID of the selected profile
var selected_profile_id: int = 0

## The location of the selected profile's save file
var save_path: String:
	get:
		return "user://%s%d.tres" % [SAVE_FILE_NAME, selected_profile_id]

func _init() -> void:
	settings = load_settings()

## Load game data and settings from disk
func load_game(profile_id: int = 0) -> void:
	selected_profile_id = profile_id
	save_data = load_game_data()

## Load game data from disk
func load_game_data() -> SaveData:
	if not ResourceLoader.exists(save_path):
		print("No save data found, creating new save")
		return default_save
	return load(save_path)
	
## Load settings from disk
func load_settings() -> Settings:
	if not ResourceLoader.exists(SETTINGS_PATH):
		print("No settings found, creating new settings")
		return Settings.new()
	return load(SETTINGS_PATH)

## Save game data and settings to disk
func save_game() -> void:
	save_game_data()
	save_settings()

## Save game data to disk
func save_game_data() -> void:
	if save_data == null:
		return
	ResourceSaver.save(save_data, save_path)
	
## Save settings to disk
func save_settings() -> void:
	ResourceSaver.save(settings, SETTINGS_PATH)

func _on_tree_exiting() -> void:
	save_game()

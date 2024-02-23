## Contains data about a particular save slot
class_name SaveData extends Resource

## The name of the scene that the player last saved at
@export_file("*.tscn") var save_scene: String

## The player's position during the last save
@export var save_position: Vector2

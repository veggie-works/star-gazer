## Contains information about a specific level's data in the game map
class_name MapLevelData extends Resource

## The location of the image file to show on the map UI
@export_file("*.png") var image_file_path: String

## The name of the level
@export var level_name: String

## The rect of this level in the map
@export var rect_in_map: Rect2

## A list of all the doors in the level
@export var doors: Array[DoorData] = []

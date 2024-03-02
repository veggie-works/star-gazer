## Contains data about a particular save slot
class_name SaveData extends Resource

## The save point that the player last saved at
@export var last_save_point: SavePointData

## A list of all save points that have been visited
@export var visited_save_points: Array[SavePointData]

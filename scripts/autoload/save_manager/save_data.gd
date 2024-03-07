## Contains data about a particular save slot
class_name SaveData extends Resource

## The save point that the player last saved at
@export var last_save_point: SavePointData = null

## A list of all save points that have been visited
@export var visited_save_points: Array[SavePointData] = []

## The player's current health value
@export var current_health: float = 100

## The player's maximum health value
@export var max_health: float = 100

## Represents a save point that the player may save or load their game from
class_name SavePointData extends Resource

## The name of the save point
@export var save_point_name: String

## The name of the scene that the save point is located in
@export_file("*.tscn") var save_scene: String

## The position of the save point
@export var save_position: Vector2

## Whether another save point data is equal to this one
func equals(other: SavePointData) -> bool:
	return save_point_name == other.save_point_name and \
		save_scene == other.save_scene and \
		save_position.distance_to(other.save_position) < 1

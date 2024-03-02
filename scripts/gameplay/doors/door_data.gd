## Represents a door with the scene that it transitions to
class_name DoorData extends Resource

## The name of the associated door
@export var door_name: String

## The global position of the associated door in the scene
@export var door_position: Vector2

## The file path of the scene that the associated door is in
@export_file("*.tscn") var door_scene: String

## The name of the door that the associated door transitions to
@export var target_door_name: String

## The file path of the scene that the associated door transitions to
@export_file("*.tscn") var target_door_scene: String

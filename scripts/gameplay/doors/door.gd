## A transition from or into another scene
class_name Door extends Area2D

## The player prefab to spawn at the door when entering from a different scene
@export var player_prefab: PackedScene

## The scene that this door transitions to when entered
@export_file("*.tscn") var target_scene: String

## The name of the door that this door leads to in the next scene
@export var target_name: String

## The direction the player should walk, jump, or fall when entering from the target door
@export_enum("left", "right", "up", "down") var enter_direction = "left"

## The door's collision shape
@onready var collision: CollisionShape2D = $collision
## The root of the level scene that contains this door
@onready var level_root: Node = get_owner()
## The target for the player to reach upon entering from this door
@onready var target: Marker2D = $target

## Data associated with this door
var data := DoorData.new()

func _ready() -> void:
	data.door_name = name
	data.door_scene = level_root.scene_file_path
	data.door_position = global_position
	data.target_door_name = target_name
	data.target_door_scene = target_scene

## Walk the player from this door into the scene
func enter_from(enter_scale: float) -> void:
	var player: Player = player_prefab.instantiate()
	player.global_position = global_position
	collision.disabled = true
	player.in_cutscene = true
	level_root.add_child(player)
	GameCamera.set_target(player)
	match enter_direction:
		"left", "right":
			var target_x = target.global_position.x
			player.run_to(target_x)
			await player.arrived
		"up":
			player.transform.x.x *= enter_scale
			while not player.is_grounded(): 
				await get_tree().process_frame
		# The enter direction for a door is the target door's direction, not its own, so a target 
		# direction of "down" would mean the player enters this door from the bottom and must jump out
		"down":
			var target_diff_x: float = abs(target.global_position.x - global_position.x)
			var target_pos := Vector2(global_position.x + target_diff_x * enter_scale, target.global_position.y)
			player.jump_to(target_pos)
			while not player.is_grounded(): 
				await get_tree().process_frame
	collision.disabled = false
	player.set_deferred("in_cutscene", false)

func _on_area_entered(area: Area2D) -> void:
	if area.get_collision_mask_value(Globals.PhysicsLayers.INTERACTIVE):
		var body: Node = area.get_owner()
		if body is Player:
			UIManager.close_all_uis()
			body.in_cutscene = true
			if enter_direction == "left" or enter_direction == "right":
				var target_sign: float = sign(global_position.x - body.global_position.x)
				var target_x: float = global_position.x + target_sign * (collision.shape.get_rect().size.x / 2 + body.get_node("collision").shape.get_rect().size.x / 2 + 64)
				body.run_to(target_x)
			SceneManager.change_scene_between_doors(target_scene, target_name, body.transform.x.x)

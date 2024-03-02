## Creates after images of the actor it is attached to
class_name AfterImageManager extends Timer

## Prefab of the after images that spawn
@export var after_image_prefab: PackedScene
## The amount of time between spawning after images
@export var interval_time: float = 0.0625
## The reference sprite to grab the after image's texture from
@export var reference_sprite: Sprite2D

## The level that will contain the after images
@onready var level: BaseLevel = get_tree().current_scene

## Create an after image of the actor
func create_after_image() -> void:
	var after_image: AfterImage = after_image_prefab.instantiate()
	after_image.texture = reference_sprite.texture
	after_image.global_transform = reference_sprite.global_transform
	level.add_child(after_image)

## Begin creating after images
func start_creating_after_images() -> void:
	start(interval_time)

## Stop creating after images	
func stop_creating_after_images() -> void:
	stop()

func _on_timeout() -> void:
	create_after_image()

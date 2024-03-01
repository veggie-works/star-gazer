## Generates a world map given all scenes listed in the scene manager
extends Node

## The max length and width that a texture may be
const MAX_TEXTURE_SIZE: int = 16384

## The frame that will enclose a captured level
@onready var frame: SubViewport = $frame
## The camera that will take a picture of the captured level
@onready var camera: Camera2D = frame.get_node("camera")

## The map resource whose level data is kept track of
var map_resource: GameMap

func _ready() -> void:
	generate_map()

## Generate the map image
func generate_map() -> void:
	GameCamera.enabled = false
	camera.make_current()
	map_resource = GameMap.new()
	for scene: PackedScene in SceneManager.level_scenes.filter(func(scene): return scene.get_state().get_node_name(0) != "main_menu"):
		var level_data := MapLevelData.new()
		var level_root: BaseLevel = scene.instantiate()
		frame.add_child(level_root)
		var tile_map: TileMap = level_root.get_node("tile_map")
		var tile_map_unit_rect: Rect2i = tile_map.get_used_rect()
		var tile_map_rect := Rect2i( \
			(tile_map_unit_rect.get_center() - tile_map_unit_rect.size / 2) * tile_map.tile_set.tile_size.x, \
			tile_map_unit_rect.size * tile_map.tile_set.tile_size.x)
		frame.size = tile_map_rect.size
		camera.global_position = tile_map_rect.get_center()
		await RenderingServer.frame_post_draw
		var image_file_path: String = "res://resources/map/%s.png" % level_root.name
		var error: Error = frame.get_texture().get_image().save_png(image_file_path)
		for door: Door in get_tree().get_nodes_in_group("doors"):
			var door_data = find_door_targeting(level_root, door)
			if door_data == null:
				level_data.position_in_map = Vector2.ZERO
				continue
			var this_pos: Vector2 = door.global_position
			var other_pos: Vector2 = door_data.door_position
			level_data.position_in_map = other_pos - this_pos
		level_data.image_file_path = image_file_path
		level_data.level_name = level_root.name
		map_resource.map_data.append(level_data)
		level_root.queue_free()
	if OS.is_debug_build():
		generate_whole_map_image()

## Find the door that transitions to a certain level and door
func find_door_targeting(level: BaseLevel, door: Door) -> DoorData:
	var found_level_data: Array[MapLevelData] = map_resource.map_data.filter(func(level: MapLevelData):
		for door_data: DoorData in level.doors:
			if door_data.target_door_name == door.name and door_data.target_door_scene == level.scene_file_path:
				return true
		return false)
	if len(found_level_data) <= 0:
		return null
	var found_door_data: Array[DoorData] = found_level_data[0].doors.filter(func(door_data: DoorData):
		return door_data.target_door_name == door.name and door_data.target_door_scene == level.scene_file_path)
	if len(found_door_data) <= 0:
		return null
		
	return found_door_data[0]

## Generate an image of the whole map with all levels placed
func generate_whole_map_image() -> void:
	var min_x = map_resource.map_data.reduce(func(current: float, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return min(level_data.position_in_map.x - level_texture.get_width() / 2, current),
	INF)
	var max_x = map_resource.map_data.reduce(func(current: float, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return max(level_data.position_in_map.x + level_texture.get_width() / 2, current),
	-INF)
	var min_y = map_resource.map_data.reduce(func(current: float, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return min(level_data.position_in_map.y - level_texture.get_height() / 2, current),
	INF)
	var max_y = map_resource.map_data.reduce(func(current: float, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return max(level_data.position_in_map.y + level_texture.get_height() / 2, current),
	-INF)
	var x_range: float = max_x - min_x
	var y_range: float = max_y - min_y
	var scale = min(x_range / 16384, y_range / 16384, 1)
	var canvas_image := Image.create(x_range, y_range, false, Image.FORMAT_RGB8)
	for level_data: MapLevelData in map_resource.map_data:
		var level_texture: Texture2D = load(level_data.image_file_path)
		var level_image: Image = level_texture.get_image()
		canvas_image.blit_rect(level_image, Rect2i(0, 0, level_image.get_width(), level_image.get_height()), level_data.position_in_map)
	canvas_image.save_png("user://generated_map.png")

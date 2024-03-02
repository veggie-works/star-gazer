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
		level_data.level_name = level_root.name
		frame.add_child(level_root)
		var tile_map: TileMap = level_root.get_node("tile_map")
		var tile_map_unit_rect: Rect2i = tile_map.get_used_rect()
		var tile_size: int = tile_map.tile_set.tile_size.x
		var tile_map_rect := Rect2(tile_map_unit_rect.position * tile_size, tile_map_unit_rect.size * tile_size)
		print("Tile map rect: ", tile_map_rect)
		frame.size = tile_map_rect.size
		camera.global_position = tile_map_rect.get_center()
		await RenderingServer.frame_post_draw
		var image_file_path: String = "res://resources/map/%s.png" % level_root.name
		var frame_image: Image = frame.get_texture().get_image()
		if frame_image.save_png(image_file_path) != OK:
			printerr("Failed to save frame image to ", image_file_path)
			continue
		level_data.image_file_path = image_file_path
		for door: Door in get_tree().get_nodes_in_group("doors"):
			var found_level_data: Array[MapLevelData] = map_resource.map_data.filter(func(level_data: MapLevelData):
				for door_data: DoorData in level_data.doors:
					print("Door: %s, %s,\tData: %s, %s" % [door_data.target_door_name, door_data.target_door_scene, door.name, level_root.scene_file_path])
					if door_data.target_door_name == door.name and door_data.target_door_scene == level_root.scene_file_path:
						return true
				return false)
			if len(found_level_data) > 0:
				var found_level: MapLevelData = found_level_data[0]
				var found_door_data: Array[DoorData] = found_level_data[0].doors.filter(func(door_data: DoorData):
					return door_data.target_door_name == door.name and door_data.target_door_scene == level_root.scene_file_path)
				if len(found_door_data) > 0:
					var found_door = found_door_data[0]
					var this_pos: Vector2 = door.global_position
					var found_rect: Rect2 = found_level.rect_in_map
					var other_pos: Vector2 = found_door.door_position
					var rect_pos: Vector2 = other_pos - this_pos + tile_map_rect.position
					level_data.rect_in_map = Rect2(rect_pos, tile_map_rect.size)
			else:
				# Scene will be at the center of the map
				level_data.rect_in_map = tile_map_rect
			print("Level rect: ", level_data.rect_in_map)
			level_data.doors.append(door.data)
		map_resource.map_data.append(level_data)
		level_root.queue_free()
	if OS.is_debug_build():
		await get_tree().create_timer(0.25).timeout
		generate_whole_map_image()

## Generate an image of the whole map with all levels placed
func generate_whole_map_image() -> void:
	var offset_x: int = map_resource.map_data.reduce(func(current: int, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return min(level_data.rect_in_map.position.x, current),
	MAX_TEXTURE_SIZE)
	var max_x: int = map_resource.map_data.reduce(func(current: int, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return max(level_data.rect_in_map.end.x, current),
	-MAX_TEXTURE_SIZE)
	var offset_y: int = map_resource.map_data.reduce(func(current: int, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return min(level_data.rect_in_map.position.y, current),
	MAX_TEXTURE_SIZE)
	var max_y: int = map_resource.map_data.reduce(func(current: int, level_data: MapLevelData):
		if not ResourceLoader.exists(level_data.image_file_path):
			print("File path doesn't exist: ", level_data.image_file_path)
			return current
		var level_texture: Texture2D = load(level_data.image_file_path)
		return max(level_data.rect_in_map.end.y, current),
	-MAX_TEXTURE_SIZE)
	var min_x: float = 0
	var min_y: float = 0
	# Offset the rect so the minimum is at (0, 0)
	max_x -= offset_x
	max_y -= offset_y
	print("Min: (%d, %d),\tMax: (%d, %d)" % [min_x, min_y, max_x, max_y])
	var x_range: int = max_x - min_x
	var y_range: int = max_y - min_y
	var scale = min(16384 / x_range, 16384 / y_range, 1)
	var canvas_image := Image.create(x_range * scale, y_range * scale, false, Image.FORMAT_RGBA8)
	for level_data: MapLevelData in map_resource.map_data:
		var level_texture: Texture2D = load(level_data.image_file_path)
		var level_image: Image = level_texture.get_image()
		var image_rect := Rect2i(0, 0, level_image.get_width(), level_image.get_height())
		var adjusted_position: Vector2 = level_data.rect_in_map.position - Vector2(offset_x, offset_y)
		print("Level pos: ", adjusted_position)
		canvas_image.blit_rect_mask(level_image, level_image, image_rect, adjusted_position)
			
	canvas_image.resize(canvas_image.get_width() / scale, canvas_image.get_height() / scale)
	canvas_image.save_png("user://generated_map.png")

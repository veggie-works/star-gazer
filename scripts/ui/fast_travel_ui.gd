## UI for fast traveling between save points
class_name FastTravelUI extends BaseUI

## The margin container containing the fast travel title label and buttons
@onready var container: VBoxContainer = $panel/margin_container/fast_travel_locations

func open() -> void:
	refresh_fast_travel_locations()
	super.open()
	
func close() -> void:
	super.close()
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	for player in players:
		if player is Player:
			player.in_cutscene = false

## Refresh the list of available fast travel locations
func refresh_fast_travel_locations() -> void:
	for child in container.get_children():
		if child is Button:
			container.remove_child(child)
	for save_point_data: SavePointData in SaveManager.save_data.visited_save_points:
		var button := Button.new()
		button.text = save_point_data.save_point_name
		button.pressed.connect(on_fast_travel_location_button_pressed.bind(save_point_data))
		if save_point_data.equals(SaveManager.save_data.last_save_point):
			button.disabled = true
		container.add_child(button)

## Callback for when a fast travel location button is pressed
func on_fast_travel_location_button_pressed(save_point_data: SavePointData) -> void:
	close()
	SceneManager.change_scene_load_save_point(save_point_data)

func _on_close_button_pressed() -> void:
	close()

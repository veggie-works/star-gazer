## Manager for all user interfaces
extends Control

## A list of all UI scenes that may be instantiated
@export var ui_scenes: Array[PackedScene] = []

## The UI canvas layer that will hold all child UIs
@onready var ui_layer: CanvasLayer = $ui_layer

## UIs that cannot be closed by pressing "ui_cancel"
var non_closeable_uis: Array[GDScript] = [
	DebugPanel,
	Fader,
	HUD,
]

## A list of all instantiated UIs
var instantiated_uis: Array[BaseUI] = []

## A list of all instantiated and open UIs
var opened_uis: Array[BaseUI]:
	get:
		return instantiated_uis.filter(func(ui): return ui.visible)

## The UI that is being shown on top of all others
var top_ui: BaseUI:
	get:
		var last_index: int = len(opened_uis) - 1
		if last_index < 0:
			return null
		return opened_uis[last_index]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if top_ui != null and not non_closeable_uis.any(func(ui): return top_ui.get_script() == ui):
			if non_closeable_uis.has(top_ui.get_script()):
				ui_layer.move_child(top_ui, 0)
			else:
				top_ui.close()
		elif get_tree().current_scene.name != "main_menu":
			var pause_menu: PauseMenu = get_ui(PauseMenu)
			if pause_menu:
				if pause_menu.visible:
					pause_menu.close()
				else:
					pause_menu.open()
			else:
				open_ui(PauseMenu)

## Close a UI
func close_ui(ui: GDScript) -> void:
	var found_uis = opened_uis.filter(func(opened_ui):
		return opened_ui.get_script() == ui
	)
	for found_ui in found_uis:
		if not non_closeable_uis.any(func(non_closeable_ui): return non_closeable_ui == found_ui):
			found_ui.close()

## Create a new instance of a UI
func create_ui(ui: GDScript, start_closed: bool = false) -> BaseUI:
	var scenes: Array[PackedScene] = ui_scenes.filter(func(scene):
		var scene_state = scene.get_state()
		for i in range(0, scene_state.get_node_property_count(0)):
			var prop_value = scene_state.get_node_property_value(0, i)
			if prop_value is GDScript and prop_value == ui:
				return prop_value
	)
	if len(scenes) <= 0:
		printerr("UI \"%s\" not found", ui.name)
		return null
	
	var instantiated_ui = scenes[0].instantiate()
	ui_layer.add_child(instantiated_ui)
	instantiated_uis.append(instantiated_ui)
	if start_closed:
		instantiated_ui.hide()
	return instantiated_ui

## Delete a UI from the scene tree
func delete_ui(ui: GDScript) -> void:
	var ui_to_delete: BaseUI = get_ui(ui)
	if ui_to_delete:
		ui_to_delete.close()
		ui_layer.remove_child(ui_to_delete)
		ui_to_delete.queue_free()
		
	instantiated_uis.erase(ui_to_delete)

## Fetch a UI instance
func get_ui(ui: GDScript) -> BaseUI:
	var found_uis = instantiated_uis.filter(func(instantiated_ui):
		return instantiated_ui.get_script() == ui
	)
	if len(found_uis) > 0:
		return found_uis[0]
		
	return null

## Open a UI
func open_ui(ui: GDScript) -> BaseUI:
	var ui_to_open: BaseUI = get_ui(ui)
	if ui_to_open == null:
		ui_to_open = create_ui(ui)
	ui_to_open.open()
	ui_layer.move_child(ui_to_open, ui_layer.get_child_count() - 1)
	return ui_to_open

## Close all open UIs
func close_all_uis() -> void:
	for ui in opened_uis:
		if not non_closeable_uis.any(func(non_closeable_ui): return non_closeable_ui == ui):
			ui.close()

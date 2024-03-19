## Panel for changing input bindings
extends Control

## The input rebinder prefab to spawn for each input binding
@export var input_rebinder_prefab: PackedScene

## Container to parent instantiated rebinder UIs to
@onready var rebinders_container = $panel/margin_container/rebinders_container

func _ready() -> void:
	for action in InputMap.get_actions().filter(func(action): return not action.contains("ui_")):
		var input_rebinder: InputRebinder = input_rebinder_prefab.instantiate()
		input_rebinder.action_name = action
		input_rebinder.key_rebound.connect(on_key_rebound)
		input_rebinder.mouse_rebound.connect(on_mouse_rebound)
		input_rebinder.joystick_rebound.connect(on_joystick_rebound)
		input_rebinder.joypad_button_rebound.connect(on_joypad_button_rebound)
		rebinders_container.add_child(input_rebinder)
		rebinders_container.move_child(input_rebinder, rebinders_container.get_child_count() - 2)

func _on_back_button_pressed() -> void:
	hide()

## Callback for when an input rebinder's key is rebound
func on_key_rebound(action_name: String, key: InputEventKey) -> void:
	for action: String in InputMap.get_actions():
		if action == action_name:
			continue
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		for event: InputEvent in events:
			if event is InputEventKey and event.physical_keycode == key.physical_keycode:
				var found_rebinders: Array[Node] = rebinders_container.get_children().filter(
					func(child): return child is InputRebinder and child.action_name == action)
				for rebinder: InputRebinder in found_rebinders:
					rebinder.clear_key_and_mouse_bindings()
		

## Callback for when an input rebinder's mouse is rebound
func on_mouse_rebound(action_name: String, button: InputEventMouseButton) -> void:
	for action: String in InputMap.get_actions():
		if action == action_name:
			continue
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		for event: InputEvent in events:
			if event is InputEventMouseButton and event.button_index == button.button_index:
				var found_rebinders: Array[Node] = rebinders_container.get_children().filter(
					func(child): return child is InputRebinder and child.action_name == action)
				for rebinder: InputRebinder in found_rebinders:
					rebinder.clear_key_and_mouse_bindings()
	
## Callback for when an input rebinder's joystick is rebound
func on_joystick_rebound(action_name: String, joystick: InputEventJoypadMotion) -> void:
	for action: String in InputMap.get_actions():
		if action == action_name:
			continue
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		for event: InputEvent in events:
			if event is InputEventJoypadMotion and event.axis == joystick.axis:
				var found_rebinders: Array[Node] = rebinders_container.get_children().filter(
					func(child): return child is InputRebinder and child.action_name == action)
				for rebinder: InputRebinder in found_rebinders:
					rebinder.clear_joypad_bindings()

	
## Callback for when an input rebinder's joypad button is rebound
func on_joypad_button_rebound(action_name: String, button: InputEventJoypadButton) -> void:
	for action: String in InputMap.get_actions():
		if action == action_name:
			continue
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		for event: InputEvent in events:
			if event is InputEventJoypadButton and event.button_index == button.button_index:
				var found_rebinders: Array[Node] = rebinders_container.get_children().filter(
					func(child): return child is InputRebinder and child.action_name == action)
				for rebinder: InputRebinder in found_rebinders:
					rebinder.clear_joypad_bindings()

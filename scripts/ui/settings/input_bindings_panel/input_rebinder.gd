## UI for rebinding an input action
class_name InputRebinder extends Control

## The name of the input action that this UI will rebind
var action_name: StringName

## Container for the rebind label and buttons
@onready var rebinder_container: HBoxContainer = $rebinder_container
## Button to begin rebinding an input action to a key or mouse button
@onready var rebind_key_or_mouse_button: Button = rebinder_container.get_node("rebind_key_or_mouse_button")
## Button to begin rebinding an input action to a joypad button
@onready var rebind_joy_button: Button = rebinder_container.get_node("rebind_joypad_button")

## Whether the input action is currently being rebound to a key or mouse button
var rebinding_key_or_mouse_button: bool

## Whether the input action is currently being rebound to a joypad button
var rebinding_joypad_button: bool

func _ready() -> void:
	var action_label = rebinder_container.get_node("action_label")
	action_label.text = action_name
	
	var action_events = InputMap.action_get_events(action_name);
	var key_or_mouse_input_actions = action_events.filter(func(event): return event is InputEventKey or event is InputEventMouseButton)
	if len(key_or_mouse_input_actions) <= 0:
		rebind_key_or_mouse_button.text = "No key/mouse binding found."
	elif key_or_mouse_input_actions[0] is InputEventKey:
		rebind_key_or_mouse_button.text = key_or_mouse_input_actions[0].as_text_key_label()
	elif key_or_mouse_input_actions[0] is InputEventMouseButton:
		rebind_key_or_mouse_button.text = key_or_mouse_input_actions[0].as_text()
		
	var joypad_input_actions = action_events.filter(func(event): return event is InputEventJoypadButton)
	if len(joypad_input_actions) <= 0:
		rebind_joy_button.text = "No joypad binding found."
	elif joypad_input_actions[0] is InputEventJoypadButton:
		rebind_joy_button.text = joypad_input_actions[0].as_text()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE or \
		event is InputEventJoypadButton and event.button_index == JOY_BUTTON_BACK:
		rebinding_key_or_mouse_button = false
		rebinding_joypad_button = false
		enable_rebind_buttons()
		return
				
	if rebinding_key_or_mouse_button:
		if event is InputEventKey:
			rebind_key(event)
			rebinding_key_or_mouse_button = false
		elif event is InputEventMouseButton:
			rebind_mouse_button(event)
			rebinding_key_or_mouse_button = false
	elif rebinding_joypad_button and event is InputEventJoypadButton:
		rebind_joypad_button(event)
		rebinding_joypad_button = false

## Clear the current key or mouse button bindings
func clear_key_and_mouse_bindings() -> void:
	var events = InputMap.action_get_events(action_name)
	var current_keys = events.filter(func(action): return action is InputEventKey)
	var current_mouse_buttons = events.filter(func(action): return action is InputEventMouseButton)
	for key in current_keys:
		InputMap.action_erase_event(action_name, key)
	for button in current_mouse_buttons:
		InputMap.action_erase_event(action_name, button)
		
## Enable or disable the rebind buttons
func enable_rebind_buttons(enable: bool = true) -> void:
	rebind_key_or_mouse_button.disabled = not enable
	rebind_joy_button.disabled = not enable

## Rebind a keyboard key
func rebind_key(key: InputEventKey) -> void:
	clear_key_and_mouse_bindings()
	InputMap.action_add_event(action_name, key)
	rebind_key_or_mouse_button.text = key.as_text_key_label()
	enable_rebind_buttons()

## Rebind a button on a mouse
func rebind_mouse_button(mouse_button: InputEventMouseButton) -> void:
	clear_key_and_mouse_bindings()
	InputMap.action_add_event(action_name, mouse_button)
	rebind_key_or_mouse_button.text = mouse_button.as_text()
	enable_rebind_buttons()

## Rebind a joypad button on a game controllerr
func rebind_joypad_button(joypad_button: InputEventJoypadButton) -> void:
	var current_joypad_buttons = InputMap.action_get_events(action_name).filter(func(action): return action is InputEventJoypadButton)
	for button in current_joypad_buttons:
		InputMap.action_erase_event(action_name, button)
	InputMap.action_add_event(action_name, joypad_button)
	rebind_joy_button.text = joypad_button.as_text()
	enable_rebind_buttons()

func _on_rebind_key_or_mouse_button_pressed() -> void:
	rebinding_key_or_mouse_button = true
	enable_rebind_buttons(false)

func _on_rebind_joypad_button_pressed() -> void:
	rebinding_joypad_button = true
	enable_rebind_buttons(false)

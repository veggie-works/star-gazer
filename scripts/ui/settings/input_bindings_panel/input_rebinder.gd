## UI for rebinding an input action
class_name InputRebinder extends Control

## The maximum amount of characters that a rebinding button can have.
const MAX_BUTTON_TEXT_CHARS: int = 32

## Emitted when the key event is rebound
signal key_rebound(action_name: String, key: InputEventKey)
## Emitted when the mouse button event is rebound
signal mouse_rebound(action_name: String, button: InputEventMouseButton)
## Emitted when the joystick event is rebound
signal joystick_rebound(action_name: String, button: InputEventJoypadMotion)
## Emitted when the joypad button event is rebound
signal joypad_button_rebound(action_name: String, button: InputEventJoypadButton)

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
var rebinding_joypad: bool

func _ready() -> void:
	var action_label = rebinder_container.get_node("action_label")
	action_label.text = action_name
	
	var action_events = InputMap.action_get_events(action_name);
	var key_or_mouse_input_actions = action_events.filter(func(event): return event is InputEventKey or event is InputEventMouseButton)
	if len(key_or_mouse_input_actions) <= 0:
		rebind_key_or_mouse_button.text = "None"
	elif key_or_mouse_input_actions[0] is InputEventKey:
		rebind_key_or_mouse_button.text = OS.get_keycode_string(key_or_mouse_input_actions[0].physical_keycode)
	elif key_or_mouse_input_actions[0] is InputEventMouseButton:
		rebind_key_or_mouse_button.text = key_or_mouse_input_actions[0].as_text()
		
	var joypad_input_actions = action_events.filter(func(event): return event is InputEventJoypadButton or event is InputEventJoypadMotion)
	if len(joypad_input_actions) <= 0:
		rebind_joy_button.text = "None"
	elif joypad_input_actions[0] is InputEventJoypadButton or joypad_input_actions[0] is InputEventJoypadMotion:
		rebind_joy_button.text = joypad_input_actions[0].as_text()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		rebinding_key_or_mouse_button = false
		rebinding_joypad = false
		enable_rebind_buttons()
		return
				
	if rebinding_key_or_mouse_button:
		if event is InputEventKey:
			rebind_key(event)
			rebinding_key_or_mouse_button = false
		elif event is InputEventMouseButton:
			rebind_mouse_button(event)
			rebinding_key_or_mouse_button = false
	elif rebinding_joypad and event is InputEventJoypadButton:
		rebind_joypad_button(event)
		rebinding_joypad = false

## Clear the current key or mouse button bindings
func clear_key_and_mouse_bindings() -> void:
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	var current_keys: Array[InputEvent] = events.filter(func(action): return action is InputEventKey)
	var current_mouse_buttons: Array[InputEvent] = events.filter(func(action): return action is InputEventMouseButton)
	for key: InputEventKey in current_keys:
		InputMap.action_erase_event(action_name, key)
		if SaveManager.settings.input_events.has(action_name):
			SaveManager.settings.input_events[action_name].erase(key)
	for button: InputEventMouseButton in current_mouse_buttons:
		InputMap.action_erase_event(action_name, button)
		if SaveManager.settings.input_events.has(action_name):
			SaveManager.settings.input_events[action_name].erase(button)
	rebind_key_or_mouse_button.text = "None"

## Clear the current joypad button bindings
func clear_joypad_bindings() -> void:
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	var current_joysticks: Array[InputEvent] = events.filter(func(action): return action is InputEventJoypadMotion)
	var current_joypad_buttons: Array[InputEvent] = events.filter(func(action): return action is InputEventJoypadButton)
	for joystick: InputEventJoypadMotion in current_joysticks:
		InputMap.action_erase_event(action_name, joystick)
		if SaveManager.settings.input_events.has(action_name):
			SaveManager.settings.input_events[action_name].erase(joystick)
	for button: InputEventJoypadButton in current_joypad_buttons:
		InputMap.action_erase_event(action_name, button)
		if SaveManager.settings.input_events.has(action_name):
			SaveManager.settings.input_events[action_name].erase(button)
	rebind_joy_button.text = "None"

## Enable or disable the rebind buttons
func enable_rebind_buttons(enable: bool = true) -> void:
	rebind_key_or_mouse_button.disabled = not enable
	rebind_joy_button.disabled = not enable

## Rebind a keyboard key
func rebind_key(key: InputEventKey) -> void:
	clear_key_and_mouse_bindings()
	InputMap.action_add_event(action_name, key)
	if SaveManager.settings.input_events.has(action_name):
		SaveManager.settings.input_events[action_name].append(key)
	else:
		SaveManager.settings.input_events[action_name] = [key]
	rebind_key_or_mouse_button.text = OS.get_keycode_string(key.physical_keycode)
	enable_rebind_buttons()
	key_rebound.emit(action_name, key)

## Rebind a button on a mouse
func rebind_mouse_button(mouse_button: InputEventMouseButton) -> void:
	clear_key_and_mouse_bindings()
	InputMap.action_add_event(action_name, mouse_button)
	if SaveManager.settings.input_events.has(action_name):
		SaveManager.settings.input_events[action_name].append(mouse_button)
	else:
		SaveManager.settings.input_events[action_name] = [mouse_button]
	rebind_key_or_mouse_button.text = mouse_button.as_text()
	enable_rebind_buttons()
	mouse_rebound.emit(action_name, mouse_button)

## Rebind a joystick on a game controllerr
func rebind_joystick(joystick: InputEventJoypadMotion) -> void:
	var current_joysticks: Array[InputEvent] = InputMap.action_get_events(action_name).filter(func(action): return action is InputEventJoypadMotion)
	for stick: InputEventJoypadMotion in current_joysticks:
		InputMap.action_erase_event(action_name, stick)
	InputMap.action_add_event(action_name, joystick)
	if SaveManager.settings.input_events.has(action_name):
		SaveManager.settings.input_events[action_name].append(joystick)
	else:
		SaveManager.settings.input_events[action_name] = [joystick]
	rebind_joy_button.text = joystick.as_text()
	enable_rebind_buttons()
	joystick_rebound.emit(action_name, joystick)

## Rebind a joypad button on a game controllerr
func rebind_joypad_button(joypad_button: InputEventJoypadButton) -> void:
	var current_joypad_buttons: Array[InputEvent] = InputMap.action_get_events(action_name).filter(func(action): return action is InputEventJoypadButton)
	for button: InputEventJoypadButton in current_joypad_buttons:
		InputMap.action_erase_event(action_name, button)
	InputMap.action_add_event(action_name, joypad_button)
	if SaveManager.settings.input_events.has(action_name):
		SaveManager.settings.input_events[action_name].append(joypad_button)
	else:
		SaveManager.settings.input_events[action_name] = [joypad_button]
	rebind_joy_button.text = joypad_button.as_text()
	enable_rebind_buttons()
	joypad_button_rebound.emit(action_name, joypad_button)

func _on_rebind_key_or_mouse_button_pressed() -> void:
	rebinding_key_or_mouse_button = true
	enable_rebind_buttons(false)

func _on_rebind_joypad_button_pressed() -> void:
	rebinding_joypad = true
	enable_rebind_buttons(false)

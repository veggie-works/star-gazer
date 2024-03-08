## Manager of player input
extends Node

## Reference to parent of all input actions
@onready var input_actions: Node = $input_actions

## Mappings from action names to their input actions
var action_map: Dictionary:
	get:
		var map: Dictionary = {}
		var actions = input_actions.get_children()
		for action in actions:
			map[action.action_name] = action
		return map

func _ready() -> void:
	var saved_events: Dictionary = SaveManager.settings.input_events
	for action: String in InputMap.get_actions().filter(func(action): return not action.contains("ui_")):
		var default_input_events: Array[InputEvent] = InputMap.action_get_events(action)
		if saved_events.has(action):
			for saved_event in saved_events.get(action):
				var matching_default_events: Array[InputEvent] = default_input_events.filter(func(default_event):
					return default_event.is_match(saved_event))
				for matching_event: InputEvent in matching_default_events:
					InputMap.action_erase_event(action, matching_event)
				InputMap.action_add_event(action, saved_event)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			# Save input bindings on game exit
			var actions: Array[StringName] = InputMap.get_actions().filter(func(action): return not action.contains("ui_"))
			for action in actions:
				var input_events: Array[InputEvent] = []
				for event in InputMap.action_get_events(action):
					input_events.append(event)
				SaveManager.settings.input_events[action] = input_events

## Check whether an input action is buffered
func is_buffered(action_name: StringName) -> bool:
	return action_map[action_name].is_buffered

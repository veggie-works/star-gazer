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
	for action: StringName in InputMap.get_actions().filter(func(action): return not action.contains("ui_")):
		if saved_events.has(action):
			var default_input_events: Array[InputEvent] = InputMap.action_get_events(action)
			for saved_event: InputEvent in saved_events.get(action):
				var matching_default_events: Array[InputEvent] = default_input_events.filter(func(default_event: InputEvent):
					return default_event.is_class(saved_event.get_class()))
				for matching_event: InputEvent in matching_default_events:
					InputMap.action_erase_event(action, matching_event)
				InputMap.action_add_event(action, saved_event)

## Check whether an input action is buffered
func is_buffered(action_name: StringName) -> bool:
	return action_map[action_name].is_buffered

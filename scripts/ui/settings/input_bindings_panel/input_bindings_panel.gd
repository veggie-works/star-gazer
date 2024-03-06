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
		rebinders_container.add_child(input_rebinder)
		rebinders_container.move_child(input_rebinder, rebinders_container.get_child_count() - 2)

func _on_back_button_pressed() -> void:
	hide()

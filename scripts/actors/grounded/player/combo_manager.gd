## Handles player attack combos
class_name ComboManager extends Node

## The number of perfect hits it takes to start a combo
const COMBO_START_COUNT: int = 3

## The maximum number of perfect hits in a combo
const COMBO_MAX: int = 5

## Emitted when a combo is started
signal combo_started

## Emitted when the max combo is reached
signal maxed_combo

## The current combo count
var combo_counter: int

## Whether the player is in a combo
var in_combo: bool:
	get:
		return combo_counter >= COMBO_START_COUNT

## Reset the current combo count
func reset_combo() -> void:
	combo_counter = 0

## Increment the combo count by 1
func increment_combo() -> void:
	combo_counter += 1
	if combo_counter == COMBO_START_COUNT:
		combo_started.emit()
	elif combo_counter >= COMBO_MAX:
		reset_combo()
		maxed_combo.emit()

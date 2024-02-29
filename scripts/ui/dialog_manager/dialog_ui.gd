## Handles dialogue between the player and an NPC
class_name DialogUI extends BaseUI

## The rate at which text is printed out, in characters per second
@export var print_speed: float = 20

## The label that dialog text will be printed on
@onready var dialog_label: Label = $margin_container/panel/margin_container/label_container/dialog_label
## Controls when text is printed out
@onready var print_timer: Timer = $print_timer

## The current dialog being displayed
var current_dialog: Dialog
## The entire contents of the current dialog's current page
var current_page: String
## The index of the current page
var current_page_index: int
## The index of the character being printed out
var current_char_index: int

## Whether text is still being printed out
var is_printing: bool:
	get:
		return current_dialog and dialog_label.text != current_page

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"):
		if is_printing:
			skip_printing()
		else:
			next_page()

func open() -> void:
	current_page_index = 0
	super.open()

func close() -> void:
	super.close()
	await get_tree().create_timer(0.25).timeout
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	for player in players:
		if player is Player:
			player.in_cutscene = false

## Show the UI with a set of dialog
func show_dialog(dialog: Dialog) -> void:
	current_dialog = dialog
	start_printing(current_page_index)

## Start printing out a dialog page's text
func start_printing(page_index: int) -> void:
	current_page_index = page_index
	current_page = current_dialog.pages[page_index]
	dialog_label.text = ""
	print_timer.start(1.0 / print_speed)
	current_char_index = 0

## Skip printing out dialog text
func skip_printing() -> void:
	dialog_label.text = current_page
	print_timer.stop()

## Proceed to the next page of dialog, or close if the last page was already reached
func next_page() -> void:
	current_page_index += 1
	if current_page_index >= len(current_dialog.pages):
		close()
		return
	start_printing(current_page_index)
	
func _on_print_timer_timeout() -> void:
	dialog_label.text += current_page[current_char_index]
	current_char_index += 1
	if current_char_index >= len(current_page):
		print_timer.stop()
		return

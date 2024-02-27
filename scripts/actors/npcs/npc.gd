## An interactable non-player character
class_name NPC extends Actor

## The dialog spoken by this NPC
@export var dialog: Dialog

## The area in which a player may interact with this NPC
@onready var interact_area: InteractArea = $interact_area

func _on_interact_area_interact() -> void:
	var dialog_ui: DialogUI = UIManager.open_ui(DialogUI)
	dialog_ui.show_dialog(dialog)

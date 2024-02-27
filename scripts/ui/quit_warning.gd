extends VBoxContainer

## Emitted when a quit is confirmed
signal quit_confirmed

## Emitted when a quit is canceled
signal quit_canceled

func _on_quit_confirm_pressed() -> void:
	quit_confirmed.emit()

func _on_quit_cancel_pressed() -> void:
	quit_canceled.emit()

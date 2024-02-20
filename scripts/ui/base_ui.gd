## Base class for all user interfaces managed by the UI manager
class_name BaseUI extends Control	

## Emitted when a UI is opened
signal opened(ui: BaseUI)
## Emitted when a UI is closed
signal closed(ui: BaseUI)

## Open the UI
func open() -> void:
	show()
	opened.emit(self)
	
## Close the UI
func close() -> void:
	hide()
	closed.emit(self)

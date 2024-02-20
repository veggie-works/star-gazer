## Displays a single item in an inventory
class_name ItemSlot extends Panel

## The item represented by the item slot
@export var slot_item: Item:
	set(item):
		if item != null:
			item_texture.texture = item.inventory_texture
		else:
			item_texture.texture = null

## The texture UI displaying the item's texture
@onready var item_texture = $item_texture

## Set the slot's item
func set_item(item: Item) -> void:
	slot_item = item
	
## Remove the slot's item
func clear_slot() -> void:
	slot_item = null

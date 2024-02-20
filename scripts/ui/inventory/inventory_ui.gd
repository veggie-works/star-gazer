## UI displaying an actor's inventory
class_name InventoryUI extends BaseUI
	
## The actor's inventory resource
@export var inventory: Inventory

## Prefab for the item slot UI
@export var item_slot_prefab: PackedScene

func _ready() -> void:
	inventory.item_added.connect(on_item_added)
	inventory.item_removed.connect(on_item_removed)

func on_item_added(item: Item) -> void:
	pass
	
func on_item_removed(item: Item) -> void:
	pass

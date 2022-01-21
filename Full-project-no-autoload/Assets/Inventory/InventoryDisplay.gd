extends GridContainer

const inventory = preload("res://Assets/Inventory/InventoryResource.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _x = inventory.connect("items_changed", self, "_on_items_changed")
	update_inventory_display()

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)


# Updates a specific slot's item
func update_inventory_slot_display(item_index: int):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)

func _on_items_changed(indexes: Array):
	for item_index in indexes:
		update_inventory_slot_display(item_index)


# If we do drop the data, we don't want input() to also execute our code
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)

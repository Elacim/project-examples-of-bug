extends ColorRect
class_name Inventory_Container

signal set_container_reference

const inventory = preload("res://Assets/Inventory/InventoryResource.tres")

func _ready() -> void:
#	rect_size = rect_size * 2
#	rect_position = rect_size / 4
	var _x = connect("set_container_reference", inventory, "_on_set_container_reference")
	emit_signal("set_container_reference", self)
	rect_size = rect_size / 2

func can_drop_data(_position, data) -> bool:
	return (data is Dictionary and data.has("item"))

func drop_data(_position: Vector2, data) -> void:
	# If the item is placed out-of-bounds, this places it back in bounds
	inventory.set_item(data.item_index, data.item)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_open_inventory"):
		if toggle_visible():
			pass
		else:
			pass

# Returns the new visiblity state once toggled
func toggle_visible() -> bool:
	if visible:
		visible = false
	else:
		visible = true
	return visible
	
func get_visible() -> bool:
	return visible

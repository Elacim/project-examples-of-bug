extends CenterContainer

# The inventory resource is not instantiated, we're simply loading a resource, this means 
# any changes to the .tres file are reflected universally (i.e. its contents are 'shared')
const inventory = preload("res://Assets/Inventory/InventoryResource.tres")

onready var item_texture_rect = $ItemTextureRect
onready var item_amount_label = $ItemTextureRect/ItemAmountLabel
onready var EmptySlot = preload("res://Assets/Inventory/EmptyInventorySlot.png")
onready var TextureRectScene = preload("res://Assets/Inventory/ItemTextureRect.tscn")
#onready var item_amount_label = $ItemTextureRect/Label
var dragPreviewOpacity = 0.5

#func _ready() -> void:
#	item_amount_label.hide()

func display_item(item):
	if item is Item:
		item_texture_rect.texture = item.texture
		update_amount_label(item.amount)
	else:
		item_texture_rect.texture = EmptySlot
		update_amount_label(0)


func update_amount_label(value: int):
#	var center_bbcode = "[center]%s[/center]"
	if !value or value <= 1:  # empty_slot is here for an easy override
#		item_amount_label.bbcode_text = ""
		item_amount_label.text = ""
	else:
		item_amount_label.text = str(value)
#		item_amount_label.text = center_bbcode % str(value)
#		item_amount_label.bbcode_text = center_bbcode % str(value)


func get_drag_data(_pos):
	var item_index = get_index()
#	var item = inventory.remove_item(item_index)
	var item = inventory.items[item_index]
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		inventory.set_drag_data(data)
		display_item(false)  # hides the item texture in the slot being dragged
		set_drag_preview(setup_drag_texture_rect(item))
		return data


# Can the slot accept drop data?
func can_drop_data(_pos, data):
#	return true
	# Is the data a dict and is the data a dict representing an item?
	return (data is Dictionary and data.has("item"))

# Executed when the data is dropped onto a slot
func drop_data(_pos, data):
	# get_index is the node's index compared to its siblings
	var myItemIndex = get_index()
	
	# Checks if the item can be combined, swapped or is rejected
	inventory.dropped_item(myItemIndex, data.item_index)
	inventory.set_drag_data(null)

func setup_drag_texture_rect(item) -> TextureRect:
	var dragPreview = TextureRectScene.instance()
	dragPreview.set_amount_on_label(item.amount)
	dragPreview.rect_size = Vector2(32, 32)
	dragPreview.expand = true
	dragPreview.texture = item.texture
	dragPreview.modulate.a = dragPreviewOpacity
	return dragPreview



extends Control
class_name Slot

var slot_number			:= 0
var temp_storage	: Item setget set_storage, get_storage # exported for debugging
export(PackedScene) var contents	 setget set_contents, get_contents  # exported for debugging
export var icon: 		Texture	setget set_icon, get_current_icon  #
onready var item_texture = $ItemTexture
onready var detector : Area2D = $DetectItem
onready var default_position : Vector2 = Vector2(0, 0)
var hover_target = false setget set_hover_target, get_hover_target


var amount_text_node
func _ready():
	rect_size = Vector2(42, 42)
	rect_min_size = Vector2(42, 42)
#	set_deferred()
	item_texture.texture = icon
	item_texture.show()


func refresh_icon():
	item_texture.texture = icon
	



func remove_contents():
	var c = contents
	set_contents(null)
	return c

func item_in_motion():
	temp_storage = contents
	remove_contents()
	
func item_restore_contents():
	set_contents(temp_storage)
	temp_storage = null

#onready var amount_text_node = $ItemAmount

func update_item_amount(to_null=false) -> void:
	amount_text_node = $ItemAmount
	if contents and !to_null:
		amount_text_node.bbcode_text = "[center]" + str(contents.amount) + "[/center]"
	if to_null:
		amount_text_node.bbcode_text = ""

#func set_contents(value: PackedScene):
func set_contents(value: Item):
	if value:
		contents = value
		set_icon(contents.in_inventory_texture)
#		if contents.amount == 0 or contents.amount == 1:
#			update_item_amount(true)
#		print_debug(contents.amount <= 1)
		update_item_amount(contents.amount <= 1)
#		if contents.amount == 1:
			# If there's one item, don't show the item count
#			update_item_amount(true)
#		else:
#			update_item_amount(false)
		# amount is stored in the item scene now
#		add_to_amount(contents.amount)
	else:
#		print_debug("Set contents and icon to null")
		contents = null
		set_icon(null)
		update_item_amount(true)
func get_contents():
	return contents

func set_storage(value):
	temp_storage = value
func get_storage():
	return temp_storage
	
func set_icon(value):
	if !value:
		icon = null
		item_texture.texture = null
		return
	elif value is Texture:
		icon = value
	elif value is String:
		icon = load(value)
	if item_texture:
		item_texture.texture = icon
	
func get_current_icon():  # Texture has a get_icon() method so it conflicts
	return icon
	



func _on_SelectItem_mouse_entered() -> void:
#	Inventory.set_hovering(self)
	get_parent().set_hovering(self)
#	emit_signal("hovering", self)
func _on_SelectItem_mouse_exited() -> void:
	pass
	# Here just in case, but I don't believe it's the right thing to do
	# We should simply let the latest call overwrite the previous
#	get_parent().set_hovering(null)

func set_hover_target(value):
	hover_target = value
func get_hover_target():
	return hover_target

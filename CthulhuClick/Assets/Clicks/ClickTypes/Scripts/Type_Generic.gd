#tool
extends Spatial
class_name Area_Generic

"""
The template for all other area types. 
Houses non-specific variables and ease-of-access nodes.
On startup, it receives the click_type and hover_identifier areas via
signals for modularity and for practice.
The hover_identifier is handled in this script, whereas click_type is handled
on a type-by-type basis - each type has it's own _on_body_entered() code
which executes the appropriate things.
"""

const inventory = preload("res://Assets/Inventory/InventoryResource.tres")

# Copy the collision from Click_Overhead into the Hover_Identifier
# You need to uncomment 'tool' at the top of the script and uncomment
# the code in '_ready()'. Exported variables don't update if tool is uncommented so be wary.
export(bool) var copy_click_collision = true

# is the area disabled (disables monitoring & monitorable)?
export(bool) var is_disabled = false setget set_disabled, get_disabled

# When the area is hovered over, what is shown at the bottom of the screen? (the identifier)
# default: the name of the parent node 
export(String) var hover_text : String

# is the area on a pickupable item?
export(bool) var is_pickupable = false setget set_is_pickupable, get_is_pickupable

# Should the node be deleted when the item is picked up?
export(bool) var delete_node_on_pickup = false

# [Dep: pickupable] Which resource does the pickupable item point to?
# i.e. When in the inventory, what resource is that item? Must be of type Item
export(Resource) var item_resource setget set_item_resource, get_item_resource 

# How many of the item should be deposited once picked up?
export(int, 1, 9999) var item_amount = 1 

# Set to true when the item is in the inventory
var was_item_picked_up = false setget set_item_picked_up, get_item_picked_up


var parent : Spatial = self

var hover_area : Area
var hover_area_coll : CollisionShape

var click_area : Area
var click_area_coll : CollisionShape

onready var anim_sprite = $AnimSprite  # we should be able to change this to a 3D model


func _ready() -> void:
	if item_resource is Item:
		pass
	else:
#		print_debug("item_resource (%s) is not a resource of type Item. It has been set to null." % item_resource)
		item_resource = null
	# [Uncomment tool] Set hover_collision to be the click_area collision
	if copy_click_collision and Engine.editor_hint:
		# makes it so it updates in editor
		pass
#		hover_area_coll.shape = click_area_coll.shape
	if !hover_text:
		hover_text = name


func _on_hover_identifier_entered(body: ClickPointer):
	if body:
#		print("Hover area entered: ", self)
#		HoverDescriptor.execute_hover_code(hover_text, self)
#		HoverDescriptor.execute_hover_code(hover_text, self)
		HoverDescriptor.add_hover_entered_event(hover_text, self)
func _on_hover_identifier_exited(body: ClickPointer):
	if body:
#		return
#		HoverDescriptor.pointer_exited_hover_area()
		HoverDescriptor.add_hover_exited_event(self)


func add_child_dialogue(dialogue_instance):
	call_deferred("add_child", dialogue_instance)

func check_if_safe():
#	if Pointer and !Pointer.is_pointer_disabled() and !inventory.get_visible():
	if Pointer and !Pointer.is_pointer_disabled():
		return true
	return false

func set_disabled(value: bool):
	if value:
		is_disabled = value
		set_deferred("monitoring", value)
		set_deferred("monitorable", value)
#		property_list_changed_notify()
func get_disabled():
	return is_disabled


func set_is_pickupable(value: bool):
	if value:
		is_pickupable = value
		if Engine.editor_hint: property_list_changed_notify()
func get_is_pickupable():
	return is_pickupable
	
func set_item_picked_up(value: bool) -> void:
	if value:
		was_item_picked_up = value
func get_item_picked_up() -> bool:
	return was_item_picked_up


func set_item_resource(value: Item):
	if value:
		item_resource = value
		if Engine.editor_hint: property_list_changed_notify()
	else:
		print_stack()
func get_item_resource():
	if get_is_pickupable():
		return item_resource
	return null


func _hover_entered(body: ClickPointer):
	if body:
		# emit_signal("show the hover_text on the label")
		pass
func _hover_exited(body: ClickPointer):
	if body:
		pass


# 			Initialisers
# These setup variables & signals at startup. These exist for modularity.
# They are safe to ignore as all they do is setup things at startup.
func _on_child_set_click_area(area: Area) -> void:
	if !area: 
		print_debug("Area not set on ", self, " (%s)" % area)
	click_area = area
	click_area_coll = area.coll
	var _x = click_area.connect("body_entered", self, "_on_click_body_entered")
	_x = click_area.connect("body_exited", self, "_on_click_body_exited")
#	print_debug("Click area set to: ", area)

func _on_child_set_hover_identifier(identifier: Area) -> void:
	if !identifier: 
		print_debug("Identifier area not set on ", self, " (%s)" % identifier)
	hover_area = identifier
	hover_area_coll = hover_area.coll
	var _x = hover_area.connect("body_entered", self, "_hover_entered")
	_x = hover_area.connect("body_exited", self, "_hover_exited")
#	print_debug("Hover area and hover area coll set to: ", over_area, hover_area_coll)



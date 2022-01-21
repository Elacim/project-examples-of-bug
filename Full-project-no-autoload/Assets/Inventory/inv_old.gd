extends Resource
class_name inv_old # would be needed for multiplayer

#signal items_changed(indexes)  # items x, y, z got updated so update them

export(Array) var test1
export(int, 1, 999) var start_slots := 10  # rename to hot_slots (?)
export(int, 1, 999) var max_slots := 999
#export(bool) var can_add_slots := true
# We could call slots "items" but we would lose our dictionary functionality then
var slots := {}
var temp_storage
#var SlotScene = preload("res://Assets/Inventory/Slot.tscn")
var is_inv_open = false setget set_inv_open, get_inv_open
var is_menu_open = false setget set_menu_open, get_menu_open

var inv_node = self


func _ready() -> void:
	for i in start_slots:
		slots[i] = null
		
func set_item(itemIndex, item):
	var previousItem = slots[itemIndex]
	slots[itemIndex] = item
	emit_signal("items_changed", [itemIndex])
	return previousItem
	
func swap_items(itemIndex, targetItemIndex):
	var currentItem = slots[itemIndex]
	var targetItem = slots[targetItemIndex]
	slots[targetItemIndex] = currentItem
	slots[currentItem] = targetItem
	emit_signal("items_changed", [itemIndex, targetItemIndex])
	
func remove_item(itemIndex):
	var previousItem = slots[itemIndex]
	slots[itemIndex] = null
	emit_signal("items_changed", [itemIndex])
	return previousItem

# Purely for debugging purposes
#var WrenchScene = preload("res://Assets/Items/Item_Wrench.tscn")  
#var BurgerScene = preload("res://Assets/Items/Item_Burger.tscn")  
#var CoinScene = preload("res://Assets/Items/Item_Coin.tscn")  

# DON'T FORGET TO RE-ENABLE THE INVENTORY SINGLETON
# If we are pressing the inventory item and holding shift, 
# attempt to combine those two items



func print_slots():
	for slot in slots:
		if !slots[slot].contents: continue
		print(slots[slot].contents.name, " ", slots[slot].contents.amount)

func show_inventory(value=true):
	if value:
		inv_node.show()
	else:
		inv_node.hide()
		


func refresh_slot_icons():
#	yield(get_tree(), "idle_frame")  # allow time for all the children to be added
	for i in slots:
		var x = slots[i]
		x.refresh_icon()


func _on_InventoryInteractMenu_id_pressed(id: int) -> void:
	pass
	
func _on_InventoryInteractMenu_popup_hide() -> void:
	set_menu_open(false)
	



# We need to be able to drag an item over another item
# then they 'combine' to create a new item
# This will be stored in a .json file or something
# Where scenes can be set like 
# {"ItemTree" : "RecipeScene" : {"Ingredients" : [Scene1, Scene2]},
#				"Scene" : {"Scenes" : }	}

func _input(event):
	if Input.is_action_just_pressed("open_inventory"):
		if get_inv_open():
#			print_debug("Inventory closed")
			set_inv_open(false)
			if Global.pointer:
				Global.pointer.enable_pointer()
		else:
#			print_debug("Inventory opened")
			set_inv_open(true)
			if Global.pointer:
				Global.pointer.disable_pointer()
	if Input.is_action_just_pressed("ui_open_interact_menu") and !get_menu_open():
		print_debug("Menu opened")
		set_menu_open(true)
	if event is InputEventMouseMotion and Input.is_action_pressed("inventory_drag_item"):
		
		pass
#	elif Input.is_action_just_pressed("inventory_drag_item")
		
#	elif Input.is_action_just_pressed("ui_open_interact_menu") and get_open():
#		print("Menu already open")
		# if this interact menu is open, the general interact menu is prevented from opening 






# Tries to add a new item to the inventory, returns true on success
# reject_on_no_space prevents the the item from going to the inventory if it's full
#func add_item_to_inventory(item: Item_Generic, icon="res://icon.png", amount=1, reject_on_no_space=true) -> bool:
func add_item_to_inventory(item: Item, reject_on_no_space=true) -> bool:
	# Name is derived from scene name
	if ((slots.size() - 1) <= max_slots):
		return false
	var available_slot = find_next_available_slot()
#	if available_slot == -1 and current_slots <= max_slots:
	if (available_slot == -1):
		if (reject_on_no_space):
			return false
		else:
			# No available slot found, so we create a new slot
			# slots.size() is equal to an undefined, new slot
			# because we start from 0
			return true
	else:
		slots[available_slot].set_contents(item)
		return true


	

func find_next_available_slot() -> int:
	for key in slots:
		if !slots[key].contents:  # if slot is empty
			return key
	return -1


func set_inv_open(value):
	is_inv_open = value
	show_inventory(value)
func get_inv_open():
	return is_inv_open

func set_menu_open(value):
	is_menu_open = value
func get_menu_open():
	return is_menu_open



## A bunch of helper functions for getting slots

# Gets the Inventory_Slot based on the given key
func get_slot_by_key(value: int) -> Slot:
	return slots[value]

# Get the key based on the given Inventory_Slot
func get_key_by_slot(value: Slot) -> int:
	for i in slots.keys():
		if slots[i] == value:
			return i
	return -1
	
# The contents aren't consistently the same
# They preferably should be PackedScenes/Scene strings
func get_slot_by_contents(value):
	for i in slots.keys():
		if slots[i]["contents"] == value:
			return i
	return -1

func get_slot_by_data(data) -> Slot:
	var s = get_slot_by_contents(data)
	if s == -1:
		return null
	return get_slot_by_key(s)




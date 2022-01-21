extends Resource
class_name Inventory

signal items_changed(indexes)

var drag_data = null setget set_drag_data, get_drag_data
var inv_container_node : ColorRect  # the visible inventory scene node

export(Array, Resource) var items = [
	null, null, null,
	null, null, null,
	null, null, null
] setget set_item_array
export(Resource) var item_table = preload("res://Assets/Items/Item_Table.tres")


func _init():
	item_table.remove_nulls()


# Attempt to add an external item into the inventory,
# returns true on success and false on failure
func add_item(item: Item):
	if item:
		var slot_idx = find_next_slot_with_item(item)
		var target_item = items[slot_idx]
		if slot_idx and target_item:
			return stack_item_with_idx(item, slot_idx)
		elif !target_item:
			set_item(slot_idx, item, true)
			return true
	return false

func stack_item_with_idx(item: Item, target_idx: int):
	var target_item = items[target_idx]
	if target_item:
		target_item.add_to_amount(item.amount)
		emit_signal("items_changed", [target_idx])
		return true
	return false


func set_item(item_index: int, item: Item, should_emit_signal:=true):
	var previousItem = items[item_index]
	items[item_index] = item
	if should_emit_signal:
		emit_signal("items_changed", [item_index])
	return previousItem
	
func swap_items(item_index, target_item_index):
	var target_item = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = target_item
	emit_signal("items_changed", [item_index, target_item_index])
	
func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem



func dropped_item(item_index, target_item_index, max_craft_amount=1):
	var item = items[item_index]
	var target_item = items[target_item_index]
	if item and target_item:
		# Places the item back to it's original position
		if item == target_item:
			set_item(item_index, item)
			return
			
		# Stacks items together (e.g. 5 coins with 10 coins = 15 coins)
		elif item.name == target_item.name:
			item.add_to_amount(target_item.amount)
			set_item(target_item_index, null)
			emit_signal("items_changed", [target_item_index, item_index])
			return

		# Try to combine the items to make a resulting recipe/product
		else:
			if try_combining_items(item, target_item, item_index, target_item_index, max_craft_amount):
				emit_signal("items_changed", stack_ununique_items())
				return
		swap_items(item_index, target_item_index)
	else:
		swap_items(item_index, target_item_index)
#	emit_signal("items_changed", [target_item_index, item_index])


# Tries to combine two items according the ingredients in any item
# If there are duplicates recipe, the first item/recipe is chosen
# Returns true if the items are combined, false if not
func try_combining_items(item, target_item, item_index, target_item_index, max_craft_amount=1):
	var combined_result = item_table.retrieve_ingredient_result(item, target_item)
#	print_debug(combined_result)
	if combined_result:
		var amount_craftable = combined_result["amount_craftable"]
		var was_item_crafted
		if amount_craftable == 1 or max_craft_amount == 1:
			was_item_crafted = craft_one_item(combined_result, [item, target_item], [item_index, target_item_index])
		elif amount_craftable > 1:
			if max_craft_amount > amount_craftable:
				for _i in range(0, amount_craftable):
					was_item_crafted = craft_one_item(combined_result, [item, target_item], [item_index, target_item_index])
					if !was_item_crafted: break
			else:
				for _i in range(0, max_craft_amount):
					was_item_crafted = craft_one_item(combined_result, [item, target_item], [item_index, target_item_index])
					if !was_item_crafted: break
		return was_item_crafted
	else:
		return false

# Craft only one item
# (e.g. 36 coins + 5 burgers = 1 wrench (31 coins + 4 burgers))
# craft_one_item(combined_result, [item, target_item], [item_index, target_item_index])
# r = combined result | ings = ingredients | ing_idx = ingredient indexes
func craft_one_item(r, ings, ing_idxs):
	var ing1_cost : int = r["ingredient1_item_cost"]
	var ing2_cost : int = r["ingredient2_target_cost"]
	var new_slot_idx : int
	var more_than_two_items := 0  # bit-flag: are there more than two items? 
	
	# These if statements are checks for testing if there will be
	# enough spare room in the inventory. The bit flag saves from complex nesting ifs.
	if (ings[0].amount - ing1_cost != 0):
		more_than_two_items += 1
	if (ings[1].amount - ing2_cost != 0):
		more_than_two_items += 2

	# there can only ever be 3 items resulting, there's no need for an array of idxs
	# If both flags are tripped, we want the resulting item to be put into a new slot
	# we should be able to change where it ends up fairly easily though
	if more_than_two_items & 1 and more_than_two_items & 2:  # if both flags were tripped:
		new_slot_idx = find_free_slot()
		if new_slot_idx == -1:
			# -1 means there is no available or newly-made slot, so don't craft the item
			return false
		ings[0].add_to_amount(-ing1_cost)
		ings[1].add_to_amount(-ing2_cost)
		set_item(new_slot_idx, r["item_result"].duplicate(), false)
		set_item(ing_idxs[0], ings[0], false)
		set_item(ing_idxs[1], ings[1], false)
		ing_idxs.push_back(new_slot_idx)
		emit_signal("items_changed", ing_idxs)

	# If ings[0]'s amount was NOT zero:
	elif more_than_two_items & 1:
		# minus the cost from ingredient 1
		ings[0].add_to_amount(-ing1_cost)
		# set the item back to itself
		set_item(ing_idxs[0], ings[0], false)
		# set the crafted result to the zero-amount ingredient 2
		set_item(ing_idxs[1], r["item_result"], false)
		emit_signal("items_changed", ing_idxs)

	# If ings[1]'s amount was NOT zero:
	elif more_than_two_items & 2:
		ings[1].add_to_amount(-ing2_cost)
		set_item(ing_idxs[0], r["item_result"], false)
		set_item(ing_idxs[1], ings[1], false)
		emit_signal("items_changed", ing_idxs)
	return true



func find_free_slot(_create_new_slot_on_fail=false):
	for idx in items.size():
		if items[idx] == null:
			return idx
	return -1

func find_next_slot_with_item(target_item: Item):
	# If we make slot_idx typed, it doesn't let us set it to null
	# If it was typed, it returns 0 which would wreak havoc
	var slot_idx = null
	if target_item:
		for idx in items.size():
			var item = items[idx]
			# If they're equal names, they can stack
			if item:
				if item.name == target_item.name:
					return idx
			
			# We go for the first null slot index only because it looks nicer in the inventory
			if !item and !slot_idx:
				slot_idx = idx
	# If set, it's only returned when no name is the same 
	return slot_idx



func set_drag_data(value):
	if value:
		drag_data = value
	else:
#		emit_signal("items_changed", drag_data.item_index)
		drag_data = value
func get_drag_data():
	return drag_data


# Purely for initialising the array and making the items unique
func set_item_array(value):
	items = value
	var changed_indexes = make_items_unique_objects()
	changed_indexes = stack_ununique_items()
	emit_signal("items_changed", changed_indexes)

func get_slot_idx_by_item(item: Item):
	return items.find(item)

func make_items_unique_objects():
	# We return changed_indexes so we can call items_changed(changed_indexes)
	var changed_indexes = []
	for idx in items.size():
		var item = items[idx]
		# if there is more than 1 of the item, it's duplicated, otherwise it's left as is
		if item and items.count(item) > 1:
			items[idx] = item.duplicate()
			changed_indexes.append(idx)
	return changed_indexes

func stack_ununique_items():
	var changed_indexes := []
	var unique_items := {}
	for idx in items.size():
		var item = items[idx]
		if item:
			if unique_items.has(item.name):
				var unique_idx = unique_items[item.name]
				items[unique_idx].add_to_amount(item.amount)
				set_item(idx, null, false)
				changed_indexes.append(idx)
				if !changed_indexes.has(unique_idx):
					changed_indexes.append(unique_idx)
			else:
				unique_items[item.name] = idx
	return changed_indexes


# I'm not a fan of this system but it seems like our best option at the moment
# Also, we can't have 'value: Inventory_Container' as it loads the 'const inventory'
# variable from Inventory_Container which leads to a cyclic reference
func _on_set_container_reference(value):
	if value:
		inv_container_node = value
func toggle_visible():
	return inv_container_node.toggle_visible()
func get_visible():
	return inv_container_node.get_visible()

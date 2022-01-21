#tool
extends Resource
class_name Item_Table

export(Array, Resource) var all_items = [null, null, null]

#export(Dictionary) var table = {}
# We need to have a table where we can check these
# It would be cool to have a proper item tree
# where recipes are easy as pie to implement - 
# we could use that RPG making tool thing..

# An easy system but not so easily editable system
# would be to have a variable that has a pointer to the
# desired item resource. It would be great to have 



func remove_nulls():
#	print_debug(all_items)
	for _i in range(0, 20):
		if null in all_items:
			# a bit hacky
			# .erase only deletes the first occurrence
			all_items.erase(null)
		else:
			# If no more nulls, break the loop early
			break
#	print(all_items)

func try_combining_items(ingredient1: Item, ingredient2: Item):
	var item = retrieve_ingredient_result(ingredient1, ingredient2)
	if item:
		pass
#	if item_table.table.has(target_item):

# Retrieves the result of what the combined ingredients are
# It's pretty much a brute-force way of doing it.
# I probably could do something fancy with indexing but I don't know how to
func retrieve_ingredient_result(ingredient1: Item, ingredient2: Item):
	# Having a dictionary would be nearly the exact same performance wise
	for item in all_items:
		if !item.ingredients[0] and !item.ingredients[1]:
			continue
		# This checks for the indexes in an item's ingredients
		# They can be placed in any order so we need to find them
		var item_ingredient_names = [item.ingredients[0].name, item.ingredients[1].name]
		var idx1 = item_ingredient_names.find(ingredient1.name)
		var idx2 = item_ingredient_names.find(ingredient2.name)
		# If the item can't be found, it returns -1, hence this if check
		if (idx1 != -1 and idx2 != -1):
			# This matches the ingredient costs to the index and
			# checks if the amount in the ingredient is enough to craft the item
			if item.ingredient_costs[idx1] <= ingredient1.amount and \
			   item.ingredient_costs[idx2] <= ingredient2.amount:
					# When this returns, it purely means the item was found
					# It does not mean the item will be added to the inventory
					return {
						"item_result" : item,
						"amount_craftable" : how_much_is_craftable(ingredient1.amount, 
						ingredient2.amount, item.ingredient_costs[idx1], item.ingredient_costs[idx2]),
						
						"ingredient1_item_cost" : item.ingredient_costs[idx1],
						"ingredient2_target_cost" : item.ingredient_costs[idx2]
						}
	return null

# Returns how many items can result from using all the ingredients
# Guaranteed to return at least 1 due to previous checks
func how_much_is_craftable(ing1_amount, ing2_amount, ing1_cost, ing2_cost):
	# division on integers rounds up, so we need to convert them to floats first
	var ing1_count = float(ing1_amount) / float(ing1_cost)
	var ing2_count = float(ing2_amount) / float(ing2_cost)
	ing1_count = int(floor(ing1_count)) 
	ing2_count = int(floor(ing2_count))
	# pick the lowest/equal count
	if ing1_count < ing2_count:  # if 4 < 9: return 4
		return ing1_count
	else: # if 9 < 4: return 4
		return ing2_count


"""
You can find the original amount by adding the amount to the cost
var combined_result keys:
item_result -> what is the resulting item from the ingredients?

ingredient1_item_cost  -> how much of an ingredient does the recipe take?
ingredient1_item_amount ->  what will the ingredient's amount be once the cost is taken away?

ingredient2_item_cost
ingredient2_item_amount
"""




#func _init() -> void:
#func _ready() -> void:
#	if Engine.editor_hint:
#		print_debug(items)
#	if !table:
#		print_debug("Item table is empty.")
#	for key in table:
#		if key is Item:
#			if key.size() => 2:
#				print("You can only have two items to represent a crafting recipe.")
#			for value in key:
#				if value is Item:
#					pass
#				else:
#					print("Error in item table! Value (%s) is not an Item resource." % value)
#		else:
#			print_debug("Error in item table! Key (%s) is not an Item resource." % key)
		

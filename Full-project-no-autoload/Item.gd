extends Resource
class_name Item


export(String) var name : String
export(Texture) var texture setget set_texture, get_texture
export(int, 0, 9999) var amount := 1
export(bool) var is_stackable = true


# What two resources (Items) is this item crafted with?
# It would be awesome for it to only select from .tres's in the Item class
# but I don't think that's possible at the moment / would require way too much work
export(Array, Resource) var ingredients = [null, null]

# How much does the recipe need of each ingredient? 
export(Array, int) var ingredient_costs = [1, 1]



func add_to_amount(value):
	amount += value

# We don't use this anywhere yet. If something is set to amount 0
# it's usually set to null anyway
func set_to_zero():
	amount = 0


func set_texture(value):
	if value is Texture or value is AnimatedTexture:
		texture = value
func get_texture():
	return texture

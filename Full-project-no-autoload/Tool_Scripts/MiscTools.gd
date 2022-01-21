extends Node
class_name MiscTools

func set_monitoring(object: Area, value: bool):
	if object and value:
		object.set_deferred("monitoring", value)
		object.set_deferred("monitorable", value)

func set_collision(object: CollisionShape, value: bool):
	if object:
#		print_debug(object, " collision set to: ", value)
		set_deferred("disabled", value)

func set_bit_layer(object: RigidBody, values: Array, change_to):
	for layer in values:
		object.set_collision_layer_bit(layer, change_to)

func set_bit_mask(object: RigidBody, values: Array, change_to):
	for mask in values:
		object.set_collision_mask_bit(mask, change_to)
	pass

#func invert_bit_layer(object, values):
#	pass
